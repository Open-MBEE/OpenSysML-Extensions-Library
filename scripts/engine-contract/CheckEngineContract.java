package io.opensysml.pilot;

import java.io.FileDescriptor;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.omg.kerml.xtext.KerMLStandaloneSetup;
import org.omg.kerml.xtext.xmi.KerMLxStandaloneSetup;
import org.omg.sysml.io.SysMLUtil;
import org.omg.sysml.lang.sysml.Element;
import org.omg.sysml.lang.sysml.Feature;
import org.omg.sysml.lang.sysml.FeatureDirectionKind;
import org.omg.sysml.lang.sysml.Function;
import org.omg.sysml.lang.sysml.Namespace;
import org.omg.sysml.lang.sysml.SysMLPackage;
import org.omg.sysml.lang.sysml.Type;
import org.omg.sysml.util.SysMLLibraryUtil;
import org.omg.sysml.xtext.SysMLStandaloneSetup;
import org.omg.sysml.xtext.xmi.SysMLxStandaloneSetup;

import com.google.inject.Injector;

/**
 * Resolves every qualified name engine-contract.json records against libraries/ loaded
 * with the standard library into one resource set, the way ValidateSysML loads them, and
 * checks the contract kind and, for functions and metadata, the bound parameters and
 * attributes. Each entry is a line of the TSV check-engine-contract.py writes:
 * name TAB kind TAB comma-separated parameters or attributes.
 *
 * <p>Prints {@code engine-contract: <name>: <reason>} per failure and exits 1 on any.
 */
public final class CheckEngineContract extends SysMLUtil {

    private static final PrintStream STDERR =
            new PrintStream(new FileOutputStream(FileDescriptor.err), true, StandardCharsets.UTF_8);

    private static final String KERNEL_LIBRARIES_DIRECTORY = "Kernel Libraries";
    private static final String SYSTEMS_LIBRARY_DIRECTORY = "Systems Library";
    private static final String DOMAIN_LIBRARIES_DIRECTORY = "Domain Libraries";

    private final List<Namespace> roots = new ArrayList<>();
    private int failures = 0;

    private CheckEngineContract() {
        super();
        setVerbose(false);
    }

    private void loadLibrary(Path library) {
        SysMLLibraryUtil.setModelLibraryDirectory(library.toString());
        readAll(library.resolve(KERNEL_LIBRARIES_DIRECTORY).toString(), false, ".kerml");
        readAll(library.resolve(SYSTEMS_LIBRARY_DIRECTORY).toString(), false, ".sysml");
        readAll(library.resolve(DOMAIN_LIBRARIES_DIRECTORY).toString(), false, ".sysml");
    }

    private void readInputs(Path dir) throws IOException {
        try (Stream<Path> walk = Files.walk(dir)) {
            for (Path file : walk.filter(Files::isRegularFile)
                    .filter(p -> p.toString().endsWith(".sysml") || p.toString().endsWith(".kerml"))
                    .sorted()
                    .toList()) {
                Resource resource = readResource(file.toString());
                for (var content : resource.getContents()) {
                    if (content instanceof Namespace namespace && content instanceof Element) {
                        roots.add(namespace);
                    }
                }
            }
        }
    }

    /** Resolve a qualified name by walking owned members by declared name from each root. */
    private Element resolve(String qualifiedName) {
        String[] segments = qualifiedName.split("::");
        for (Namespace root : roots) {
            Element element = walk(root, segments, 0);
            if (element != null) {
                return element;
            }
        }
        return null;
    }

    private Element walk(Namespace scope, String[] segments, int index) {
        for (var member : scope.getOwnedMember()) {
            // Semantic-metadata keywords bind by declared short name: `#choice`
            // resolves ChoiceMetadata the way `StateMachines::choice` does.
            if (member instanceof Element element
                    && (segments[index].equals(element.getDeclaredName())
                            || segments[index].equals(element.getDeclaredShortName()))) {
                if (index == segments.length - 1) {
                    return element;
                }
                if (element instanceof Namespace namespace) {
                    Element found = walk(namespace, segments, index + 1);
                    if (found != null) {
                        return found;
                    }
                }
            }
        }
        return null;
    }

    private void fail(String name, String reason) {
        STDERR.println("engine-contract: " + name + ": " + reason);
        failures++;
    }

    private void check(String name, String kind, String spec) {
        Element element = resolve(name);
        if (element == null) {
            fail(name, "no element of that name resolves in libraries/");
            return;
        }
        List<String> specList = spec.isEmpty() ? List.of() : List.of(spec.split(","));
        switch (kind) {
            case "package" -> {
                if (!(element instanceof Namespace)) {
                    fail(name, "not a Namespace: " + element.eClass().getName());
                }
            }
            case "function" -> {
                if (!(element instanceof Function function)) {
                    fail(name, "not a Function: " + element.eClass().getName());
                    break;
                }
                List<String> parameters = new ArrayList<>();
                for (Feature feature : function.getOwnedFeature()) {
                    if (feature.getDirection() == FeatureDirectionKind.IN
                            || feature.getDirection() == FeatureDirectionKind.INOUT) {
                        parameters.add(feature.getDeclaredName());
                    }
                }
                if (!parameters.equals(specList)) {
                    fail(name, "parameters " + parameters + " != " + specList);
                }
            }
            case "metadata" -> {
                if (!(element instanceof Type type)) {
                    fail(name, "not a Type: " + element.eClass().getName());
                    break;
                }
                if (specList.isEmpty()) {
                    break;
                }
                List<String> features = new ArrayList<>();
                for (Feature feature : type.getFeature()) {
                    features.add(feature.getDeclaredName());
                }
                for (String attribute : specList) {
                    if (!features.contains(attribute)) {
                        fail(name, "no feature named " + attribute);
                    }
                }
            }
            case "document", "element" -> {
                // Existence is the whole check.
            }
            default -> fail(name, "unknown kind " + kind);
        }
    }

    public static void main(String[] args) {
        if (args.length != 3) {
            STDERR.println("usage: check-engine-contract --library DIR --inputs DIR TSV");
            STDERR.println("       arguments: <library-dir> <libraries-dir> <tsv-file>");
            System.exit(2);
        }
        Path library = Paths.get(args[0]).toAbsolutePath().normalize();
        Path inputs = Paths.get(args[1]).toAbsolutePath().normalize();
        Path tsv = Paths.get(args[2]).toAbsolutePath().normalize();
        try {
            EPackage.Registry.INSTANCE.put(
                    "https://www.omg.org/spec/SysML/20250201", SysMLPackage.eINSTANCE);
            KerMLStandaloneSetup.doSetup();
            KerMLxStandaloneSetup.doSetup();
            SysMLxStandaloneSetup.doSetup();
            Injector injector = new SysMLStandaloneSetup().createInjectorAndDoEMFRegistration();
            injector.getInstance(org.eclipse.xtext.validation.IResourceValidator.class);

            CheckEngineContract instance = new CheckEngineContract();
            instance.loadLibrary(library);
            instance.readInputs(inputs);
            for (String line : Files.readAllLines(tsv, StandardCharsets.UTF_8)) {
                if (line.isBlank() || line.startsWith("#")) {
                    continue;
                }
                String[] fields = line.split("\t", -1);
                String spec = fields.length > 2 ? fields[2] : "";
                instance.check(fields[0], fields[1], spec);
            }
            System.exit(instance.failures == 0 ? 0 : 1);
        } catch (Throwable e) {
            STDERR.println("Error: " + e);
            System.exit(3);
        }
    }
}
