library package NPR7120 {
	doc /* NON-NORMATIVE OpenSysML vocabulary for NASA Procedural Requirements NPR 7120.5F, 'NASA
	 * Space Flight Program and Project Management Requirements', as amended by NASA Interim
	 * Directive NID 7120.148 (effective 2024-12-09), which the NASA Online Directives Information
	 * System (NODIS) lists as holding the most recent requirements for the NPR:
	 * https://nodis3.gsfc.nasa.gov/displayDir.cfm?c=7120&s=5F&t=NPR. The directive is a work of
	 * the United States Government; the library quotes its text verbatim where it defines a term
	 * or states a requirement, with the section, table or figure the text comes from. The library
	 * is a community extension: it is not endorsed by NASA and it does not replace the NPR, the
	 * NASA Space Flight Program and Project Management Handbook or a Mission Directorate's or
	 * Center's implementing procedures. It lets a program or project model, in standard SysML v2,
	 * the program types and project categories of section 2.1, the four life cycles of Figures
	 * 2-2 to 2-5 with their stages and phases, the key decision points and life-cycle reviews of
	 * Tables 2-3 to 2-6 with the objectives and expected maturity states the tables state, the
	 * oversight roles and authority documents of sections 2.2.3, 2.3 and 2.4, and the
	 * requirements and compliance matrix of Appendix C (Table C-1). It builds on the NPR7123
	 * library, whose life-cycle phases and key decision points defer to this NPR: a key decision
	 * point here specialises NPR7123::KeyDecisionPoint, a life-cycle review
	 * NPR7123::LifeCycleReview, and an authority document NPR7123::WorkProduct. Not modelled: the
	 * per-review maturity cells of the Appendix I tables (Table C-1 carries each product's
	 * baseline point), the document templates of Appendices D to H and J, and the roles and
	 * responsibilities of chapter 3.
	 */

	private import ScalarValues::Boolean;
	private import ScalarValues::Integer;
	private import ScalarValues::String;
	private import Metaobjects::SemanticMetadata;
	private import KerML::Root::Element;
	private import Occurrences::occurrences;
	private import Actions::Action;
	private import Actions::actions;
	private import Parts::Part;
	private import Parts::parts;
	private import Requirements::RequirementCheck;
	private import Requirements::requirementChecks;
	private import StandardViewDefinitions::*;
	private import Views::asElementTable;
	private import DocumentQueries::*;
	private import NPR7123::KeyDecisionPoint;
	private import NPR7123::keyDecisionPoints;
	private import NPR7123::LifeCycleReview;
	private import NPR7123::lifeCycleReviews;
	private import NPR7123::ReviewKind;
	private import NPR7123::WorkProduct;
	private import NPR7123::workProducts;
	private import NPR7123::ComplyKind;

	/* Section 2.1: programs, projects and their categories */

	enum def ProgramKind {
		doc /* The four program types of section 2.1.2 (definitions from Appendix A). */
		singleProject {
			doc /* Single-project program: a program that tends 'to have long development and/or
			 * operational lifetimes, represent a large investment of Agency resources, and have
			 * contributions from multiple organizations/agencies'; it follows the life cycle of
			 * Figure 2-4.
			 */
		}
		uncoupled {
			doc /* Uncoupled program: a program 'implemented under a broad theme and/or a common
			 * program implementation concept'; each project 'is independent of the other
			 * projects within the program' (Figure 2-2).
			 */
		}
		looselyCoupled {
			doc /* Loosely coupled program: a program that addresses 'specific objectives through
			 * multiple space flight projects of varied scope'; synergies 'that benefit the
			 * program as a whole are explored during the Formulation process' (Figure 2-2).
			 */
		}
		tightlyCoupled {
			doc /* Tightly coupled program: a program with 'multiple projects that execute portions
			 * of a mission(s)'; no single project can implement a complete mission (Figure 2-3).
			 */
		}
	}

	enum def ProjectCategory {
		doc /* 'Projects are Category 1, 2, or 3 and shall be assigned to a category based
		 * initially on: (1) the project life-cycle cost (LCC) estimate, the inclusion of
		 * significant radioactive material, and whether or not the system being developed is for
		 * human space flight; and (2) the priority level' (section 2.1.3.1, Table 2-1). The NASA
		 * Associate Administrator approves the final categorization.
		 */
		category1 {
			doc /* Table 2-1: LCC over $2B, significant radioactive material, or human space
			 * flight, at any priority level.
			 */
		}
		category2 {
			doc /* Table 2-1: LCC from $365M to $2B at any priority level, or LCC under $365M at
			 * high priority.
			 */
		}
		category3 {
			doc /* Table 2-1: LCC under $365M at medium or low priority. */
		}
	}

	enum def LifeCycleKind {
		doc /* The four life cycles of section 2.2: 'Program and project managers shall follow
		 * their appropriate life cycle as identified in each program and project respective
		 * life-cycle figure.' (section 2.2.1)
		 */
		uncoupledOrLooselyCoupledProgram {
			doc /* Figure 2-2, NASA Uncoupled and Loosely Coupled Program Life Cycle. */
		}
		tightlyCoupledProgram {
			doc /* Figure 2-3, NASA Tightly Coupled Program Life Cycle. */
		}
		singleProjectProgram {
			doc /* Figure 2-4, NASA Single-Project Program Life Cycle. */
		}
		project {
			doc /* Figure 2-5, NASA Project Life Cycle. */
		}
	}

	/* Section 2.2 and Figures 2-2 to 2-5: stages and phases */

	enum def LifeCycleStage {
		doc /* The three divisions every life-cycle figure draws, separated by Approval for
		 * Formulation and Approval for Implementation.
		 */
		preFormulation {
			doc /* Before Approval for Formulation; Pre-Phase A of a project or single-project
			 * program.
			 */
		}
		formulation {
			doc /* From Approval for Formulation to Approval for Implementation; Phases A and B of
			 * a project or single-project program.
			 */
		}
		implementation {
			doc /* From Approval for Implementation onward; Phases C to F of a project or
			 * single-project program.
			 */
		}
	}

	attribute def PhaseDescription {
		doc /* What Figures 2-4 and 2-5 state for a phase: its title and the stage it lies in. */
		attribute title : String;
		attribute stage : LifeCycleStage;
	}

	enum def ProjectPhase :> PhaseDescription {
		doc /* The phases of a project or single-project program (Figures 2-4 and 2-5). Programs
		 * of the other three types have stages but no lettered phases. 'Transition to the
		 * following phase occurs immediately following KDP approval except for the transition
		 * from Phase D to E, where transition occurs following on-orbit checkout.' (section 2.2.7)
		 */
		prePhaseA {
			doc /* Pre-Phase A, closed by KDP A. */
			:>> title = "Concept Studies";
			:>> stage = LifeCycleStage::preFormulation;
		}
		phaseA {
			doc /* Phase A, closed by KDP B. */
			:>> title = "Concept and Technology Development";
			:>> stage = LifeCycleStage::formulation;
		}
		phaseB {
			doc /* Phase B, closed by KDP C, the Approval for Implementation. */
			:>> title = "Preliminary Design and Technology Completion";
			:>> stage = LifeCycleStage::formulation;
		}
		phaseC {
			doc /* Phase C, closed by KDP D. */
			:>> title = "Final Design and Fabrication";
			:>> stage = LifeCycleStage::implementation;
		}
		phaseD {
			doc /* Phase D, closed by KDP E and on-orbit checkout. */
			:>> title = "System Assembly, Integration and Test, Launch and Checkout";
			:>> stage = LifeCycleStage::implementation;
		}
		phaseE {
			doc /* Phase E, closed by KDP F. */
			:>> title = "Operations and Sustainment";
			:>> stage = LifeCycleStage::implementation;
		}
		phaseF {
			doc /* Phase F, which ends with the final archival of data. */
			:>> title = "Closeout";
			:>> stage = LifeCycleStage::implementation;
		}
	}

	/* Section 2.3: oversight and approval */

	enum def DecisionAuthorityKind {
		doc /* Who holds Decision Authority (section 2.3). */
		nasaAssociateAdministrator {
			doc /* 'For programs and Category 1 projects, the Decision Authority is the NASA AA.
			 * The NASA AA may delegate this authority to the MDAA.'
			 */
		}
		missionDirectorateAssociateAdministrator {
			doc /* 'For Category 2 and 3 projects, the Decision Authority is the MDAA.' */
		}
		centerDirector {
			doc /* 'Decision authority may be delegated to a Center Director for determining
			 * whether Category 2 and 3 projects may proceed through KDPs into the next phase of
			 * the life cycle.'
			 */
		}
	}

	part def DecisionAuthority :> Part {
		doc /* 'Each program and project shall have a Decision Authority, the Agency's responsible
		 * individual who determines whether and how the program or project proceeds through the
		 * life cycle and the key program or project cost, schedule, and content parameters that
		 * govern the remaining life-cycle activities.' (section 2.3)
		 */
		attribute kind : DecisionAuthorityKind;
		attribute holder : String[0..1];
	}

	abstract part decisionAuthorities : DecisionAuthority[0..*] nonunique :> parts;

	enum def ManagementCouncilKind {
		doc /* The management councils of sections 2.3.2 and 2.3.4. */
		agencyPMC {
			doc /* Agency Program Management Council (APMC): 'For all programs and Category 1
			 * projects, the governing PMC is the APMC'.
			 */
		}
		missionDirectoratePMC {
			doc /* Mission Directorate PMC (DPMC): 'for Category 2 and 3 projects, the governing
			 * PMC is the DPMC'.
			 */
		}
		centerManagementCouncil {
			doc /* Center Management Council (CMC), which 'monitors and evaluates all program and
			 * project work (regardless of category) executed at that Center'; the PMC function
			 * may be delegated to it when Decision Authority is delegated to the Center.
			 */
		}
		integratedCenterManagementCouncil {
			doc /* Integrated Center Management Council (ICMC), used for programs and projects
			 * conducted by multiple Centers.
			 */
		}
	}

	part def ManagementCouncil :> Part {
		doc /* A management council. 'Each program and project shall have a governing PMC.' The
		 * PMCs periodically evaluate 'the technical, safety, health and medical, and programmatic
		 * performance (including cost, schedule, risk, and risk mitigation) and content of a
		 * program or project under their purview' (section 2.3.2).
		 */
		attribute kind : ManagementCouncilKind;
	}

	abstract part managementCouncils : ManagementCouncil[0..*] nonunique :> parts;

	part def StandingReviewBoard :> Part {
		doc /* The independent Standing Review Board (SRB) that, with the program or project
		 * manager, conducts the SRR, SDR/MDR, PDR, CDR, SIR, ORR and PIR life-cycle reviews
		 * (section 2.2.5); the Convening Authorities of Table 2-2 convene it.
		 */
		attribute chair : String[0..1];
	}

	abstract part standingReviewBoards : StandingReviewBoard[0..*] nonunique :> parts;

	enum def AssessmentCriterion {
		doc /* The six criteria by which a life-cycle review assesses 'the program's or project's
		 * technical and programmatic status and health at key points in the life cycle'
		 * (section 2.2.4).
		 */
		strategicAlignment {
			doc /* 'alignment with and contribution to Agency strategic goals' */
		}
		managementApproach {
			doc /* 'adequacy of management approach' */
		}
		technicalApproach {
			doc /* 'adequacy of technical approach' */
		}
		costAndSchedule {
			doc /* 'adequacy of the integrated cost and schedule estimates and funding strategy' */
		}
		resourcesOtherThanBudget {
			doc /* 'adequacy and availability of resources other than budget' */
		}
		riskManagementApproach {
			doc /* 'adequacy of the risk management approach' */
		}
	}

	part def SpaceFlightProgram :> Part {
		doc /* A space flight program: 'A strategic investment by Mission Directorates or mission
		 * support offices that has a defined architecture and/or technical approach,
		 * requirements, funding level, and management structure that initiates and directs one
		 * or more projects.' (Appendix A). Its kind selects its life cycle.
		 */
		attribute kind : ProgramKind;
		attribute lifeCycle : LifeCycleKind[0..1];
		part decisionAuthority : DecisionAuthority[0..1] :> decisionAuthorities;
		part governingPMC : ManagementCouncil[0..1] :> managementCouncils;
		ref part projects : SpaceFlightProject[0..*] :> spaceFlightProjects;
	}

	abstract part spaceFlightPrograms : SpaceFlightProgram[0..*] nonunique :> parts;

	part def SpaceFlightProject :> Part {
		doc /* A space flight project: 'a specific investment identified in a Program Plan having
		 * defined requirements, a life-cycle cost, a beginning, and an end' (Appendix A). A
		 * usage states its category and the phase it is in.
		 */
		attribute category : ProjectCategory[0..1];
		attribute phase : ProjectPhase[0..1];
		part decisionAuthority : DecisionAuthority[0..1] :> decisionAuthorities;
		part governingPMC : ManagementCouncil[0..1] :> managementCouncils;
	}

	abstract part spaceFlightProjects : SpaceFlightProject[0..*] nonunique :> parts;

	/* Sections 2.2.3 and 2.4: authority documents, baselines and commitments */

	abstract part def AuthorityDocument :> Document, WorkProduct {
		doc /* A principal document that governs the conduct of a phase (section 2.2.1). 'The
		 * documents shown on the life-cycle figures ... shall be prepared in accordance with the
		 * templates in appendices D, E, F, G, H, and J.' (section 2.2.3)
		 */
		:>> title default = "Authority Document";
	}

	abstract part authorityDocuments : AuthorityDocument[0..*] nonunique :> parts, workProducts;

	part def PreFormulationApprovalLetter :> AuthorityDocument {
		doc /* Pre-Formulation Approval Letter (PFAL, Appendix J): issued by the MDAA, it gives
		 * 'the approval authorization ... to initiate pre-formulation' and 'specifies the
		 * activities and products to be completed in Pre-Phase A for a single-Project Program,
		 * Category 1 Project, and select Category 2 Projects' (section 2.2.3.1).
		 */
		:>> title default = "Pre-Formulation Approval Letter";
	}

	part def FormulationAuthorizationDocument :> AuthorityDocument {
		doc /* Formulation Authorization Document (FAD, Appendix E): prepared by the Mission
		 * Directorate, it authorizes a program or project manager 'to initiate the planning of a
		 * new program' or project (sections 2.2.3.2 and 2.2.3.4).
		 */
		:>> title default = "Formulation Authorization Document";
	}

	part def ProgramCommitmentAgreement :> AuthorityDocument {
		doc /* Program Commitment Agreement (PCA, Appendix D): 'an agreement between the MDAA and
		 * the NASA AA (the Decision Authority) that authorizes program transition from
		 * Formulation to Implementation' (section 2.2.3.3).
		 */
		:>> title default = "Program Commitment Agreement";
	}

	part def FormulationAgreement :> AuthorityDocument {
		doc /* Formulation Agreement (Appendix F): 'prepared by the project in response to the FAD
		 * to establish the technical and acquisition work that needs to be conducted during
		 * Formulation'; it 'defines the schedule and funding requirements during Phase A and
		 * Phase B for that work' (section 2.2.3.5).
		 */
		:>> title default = "Formulation Agreement";
	}

	part def ProgramPlan :> AuthorityDocument {
		doc /* Program Plan (Appendix G): 'an agreement between the MDAA (who has final approval
		 * authority for the plan), the participating Center Director(s), and the program
		 * manager' (section 2.2.3.4).
		 */
		:>> title default = "Program Plan";
	}

	part def ProjectPlan :> AuthorityDocument {
		doc /* Project Plan (Appendix H): 'an agreement among the MDAA; the program manager;
		 * participating Center Director(s); the project manager; and for AO-selected missions,
		 * the principal investigator' (section 2.2.3.7).
		 */
		:>> title default = "Project Plan";
	}

	part def DecisionMemorandum :> AuthorityDocument {
		doc /* The Decision Memorandum of a KDP: 'The decisions by the Decision Authority on
		 * whether and how the program or project proceeds into the next phase shall be
		 * summarized and recorded in the Decision Memorandum signed at the conclusion of the
		 * governing PMC' (section 2.4.1). It contains the Management Agreement, which 'defines
		 * the parameters and authorities over which the program or project manager has
		 * management control' (section 2.4.1.2).
		 */
		:>> title default = "Decision Memorandum";
		attribute managementAgreement : String[0..1];
		attribute jointConfidenceLevelPercent : Integer[0..1] {
			doc /* The joint cost and schedule confidence level (JCL) the memorandum records, where
			 * section 2.4.3 requires one.
			 */
		}
		attribute establishesAgencyBaselineCommitment : Boolean default false {
			doc /* True for the memorandum that sets the Agency Baseline Commitment (ABC), 'the
			 * baseline against which the Agency's performance is measured during the
			 * Implementation Phase'; for a project or single-project program that is the one at
			 * KDP C (section 2.4.1.5).
			 */
		}
	}

	/* Section 2.2.7 and Tables 2-3 to 2-5: key decision points */

	occurrence def SpaceFlightKeyDecisionPoint :> KeyDecisionPoint {
		doc /* A key decision point of NPR 7120.5: 'the event where the Decision Authority
		 * determines the readiness of a program or project to progress to the next phase of the
		 * life cycle and establishes the content, cost, and schedule commitments for the ensuing
		 * phase(s)' (section 2.2.7). 'KDPs associated with uncoupled, loosely coupled, and
		 * tightly coupled programs are designated with Roman numerals and zero. ... KDPs for
		 * projects and single-project programs are designated with letters'. The definitions of
		 * KeyDecisionPoints document the expected maturity state Tables 2-3 to 2-5 give each.
		 */
		attribute lifeCycle : LifeCycleKind[0..1];
		attribute closes : ProjectPhase[0..1] {
			doc /* The phase the KDP closes, for a project or single-project program. */
		}
		ref part decisionAuthority : DecisionAuthority[0..1] :> decisionAuthorities;
		ref part governingPMC : ManagementCouncil[0..1] :> managementCouncils;
		ref part decisionMemorandum : DecisionMemorandum[0..1] :> authorityDocuments;
	}

	abstract occurrence spaceFlightKeyDecisionPoints : SpaceFlightKeyDecisionPoint[0..*] nonunique :> keyDecisionPoints;

	package KeyDecisionPoints {
		doc /* The key decision points of the four life cycles, one definition each. The
		 * documentation of a definition opens with the 'Overall Expected Maturity State at KDP'
		 * Tables 2-3 to 2-5 give it. 'LCR entrance and success criteria in NPR 7123.1 and the
		 * life-cycle phase and KDP information in the NASA Space Flight Program and Project
		 * Management Handbook provide specifics for addressing the six criteria required to
		 * demonstrate the program or project has met expected maturity state.' (note to Tables
		 * 2-3 to 2-5)
		 */

		package UncoupledAndLooselyCoupledProgram {
			doc /* The key decision points of an uncoupled or loosely coupled program (Figure 2-2,
			 * Table 2-3).
			 */

			occurrence def ProgramKDP0 :> SpaceFlightKeyDecisionPoint {
				doc /* KDP 0 (Table 2-3). Expected maturity state: 'Program addresses critical NASA
				 * needs and can likely be achieved as conceived.' Informed by the SRR. Figure
				 * 2-2: KDP 0 may be required by the Decision Authority to ensure major issues
				 * are understood and resolved prior to formal program approval at KDP I.
				 */
				:>> designation = "KDP 0";
				:>> lifeCycle = LifeCycleKind::uncoupledOrLooselyCoupledProgram;
			}

			occurrence def ProgramKDPI :> SpaceFlightKeyDecisionPoint {
				doc /* KDP I (Table 2-3). Expected maturity state: 'Program is in place and stable,
				 * addresses critical NASA needs, has adequately completed Formulation
				 * activities, has an acceptable plan for Implementation that leads to mission
				 * success, has proposed projects that are feasible within available resources,
				 * and has risks that are commensurate with the Agency’s expectations.' Informed
				 * by the SDR; the Approval for Implementation.
				 */
				:>> designation = "KDP I";
				:>> lifeCycle = LifeCycleKind::uncoupledOrLooselyCoupledProgram;
			}

			occurrence def ProgramKDPII :> SpaceFlightKeyDecisionPoint {
				doc /* KDP II (Table 2-3). Expected maturity state: 'Program still meets Agency
				 * needs and is continuing to meet Agency commitments, as planned.' The row
				 * covers KDP II to KDP n, each informed by a PIR; redefine `designation` for a
				 * later one.
				 */
				:>> designation default = "KDP II";
				:>> lifeCycle = LifeCycleKind::uncoupledOrLooselyCoupledProgram;
			}
		}

		package TightlyCoupledProgram {
			doc /* The key decision points of a tightly coupled program (Figure 2-3, Table 2-4). */

			occurrence def TightlyCoupledKDP0 :> SpaceFlightKeyDecisionPoint {
				doc /* KDP 0 (Table 2-4). Expected maturity state: 'Program addresses critical NASA
				 * needs, and projects are feasible within available resources.' Informed by the
				 * SRR and the SDR.
				 */
				:>> designation = "KDP 0";
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
			}

			occurrence def TightlyCoupledKDPI :> SpaceFlightKeyDecisionPoint {
				doc /* KDP I (Table 2-4). Expected maturity state: 'Program is in place and stable,
				 * addresses critical NASA needs, has adequately completed Formulation
				 * activities, and has an acceptable plan for Implementation that leads to
				 * mission success. Proposed projects are feasible with acceptable risk within
				 * Agency cost and schedule baselines.' Informed by the PDR; the Approval for
				 * Implementation.
				 */
				:>> designation = "KDP I";
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
			}

			occurrence def TightlyCoupledKDPII :> SpaceFlightKeyDecisionPoint {
				doc /* KDP II (Table 2-4). Expected maturity state: 'Program is still on plan. The
				 * risk is commensurate with the projects’ payload classifications. The program
				 * is ready for Assembly, Integration, and Test (AI&T) with acceptable risk
				 * within Agency cost and schedule baselines.' Informed by the CDR and the SIR.
				 */
				:>> designation = "KDP II";
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
			}

			occurrence def TightlyCoupledKDPIII :> SpaceFlightKeyDecisionPoint {
				doc /* KDP III (Table 2-4). Expected maturity state: 'Program is ready for launch
				 * and early operations with acceptable risk within Agency cost and schedule
				 * baselines.' Informed by the ORR and the FRR or MRR.
				 */
				:>> designation = "KDP III";
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
			}

			occurrence def TightlyCoupledKDPIV :> SpaceFlightKeyDecisionPoint {
				doc /* KDP IV (Table 2-4). Expected maturity state: 'Program still meets Agency
				 * needs and is continuing with acceptable risk within Agency cost and schedule
				 * baselines.' The row covers KDP IV to KDP n-1, each informed by a PIR;
				 * redefine `designation` for a later one.
				 */
				:>> designation default = "KDP IV";
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
			}

			occurrence def TightlyCoupledKDPn :> SpaceFlightKeyDecisionPoint {
				doc /* KDP n (Table 2-4). Expected maturity state: 'Program decommissioning is
				 * consistent with program objectives and is ready for final analysis and
				 * archival of mission and science data and safe disposal of its assets.' The
				 * last KDP, informed by the DR; redefine `designation` with its numeral.
				 */
				:>> designation default = "KDP n";
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
			}
		}

		package ProjectAndSingleProjectProgram {
			doc /* The key decision points of a project or single-project program (Figures 2-4 and
			 * 2-5, Table 2-5). `lifeCycle` is left open because both life cycles share them.
			 */

			occurrence def KDPA :> SpaceFlightKeyDecisionPoint {
				doc /* KDP A (Table 2-5). Expected maturity state: 'Project addresses critical NASA
				 * need. Proposed mission concept(s) is feasible. Associated planning is
				 * sufficiently mature to begin Phase A, and the mission can likely be achieved
				 * as conceived.' Informed by the MCR. For a mission selected through an
				 * Announcement of Opportunity, KDP A is the selection of a Step 1 proposal for
				 * concept development (section 2.2.7.1).
				 */
				:>> designation = "KDP A";
				:>> closes = ProjectPhase::prePhaseA;
			}

			occurrence def KDPB :> SpaceFlightKeyDecisionPoint {
				doc /* KDP B (Table 2-5). Expected maturity state: 'Proposed mission/system
				 * architecture is credible and responsive to program requirements and
				 * constraints, including resources. The maturity of the project’s
				 * mission/system definition and associated plans is sufficient to begin Phase
				 * B, and the mission can likely be achieved within available resources with
				 * acceptable risk.' Informed by the SRR and the MDR or SDR. In a two-step
				 * Announcement of Opportunity the down-selection serves as KDP B (section
				 * 2.2.7.1).
				 */
				:>> designation = "KDP B";
				:>> closes = ProjectPhase::phaseA;
			}

			occurrence def KDPC :> SpaceFlightKeyDecisionPoint {
				doc /* KDP C (Table 2-5). Expected maturity state: 'Project’s planning, technical,
				 * cost, and schedule baselines developed during Formulation are complete and
				 * consistent. The preliminary design complies with its requirements. The
				 * project is sufficiently mature to begin Phase C, and the cost and schedule
				 * are adequate to enable mission success with acceptable risk.' Informed by the
				 * PDR; the Approval for Implementation, whose Decision Memorandum sets the
				 * Agency Baseline Commitment (section 2.4.1.5).
				 */
				:>> designation = "KDP C";
				:>> closes = ProjectPhase::phaseB;
			}

			occurrence def KDPD :> SpaceFlightKeyDecisionPoint {
				doc /* KDP D (Table 2-5). Expected maturity state: 'Project is still on plan. The
				 * risk is commensurate with the project’s payload classification, and the
				 * project is ready for AI&T with acceptable risk within its ABC.' Informed by
				 * the CDR, the PRR and the SIR.
				 */
				:>> designation = "KDP D";
				:>> closes = ProjectPhase::phaseC;
			}

			occurrence def KDPE :> SpaceFlightKeyDecisionPoint {
				doc /* KDP E (Table 2-5). Expected maturity state: 'Project and all supporting
				 * systems are ready for safe, successful launch and early operations with
				 * acceptable risk within ABC.' Informed by the ORR and the MRR or FRR; Phase E
				 * begins after on-orbit checkout (section 2.2.7).
				 */
				:>> designation = "KDP E";
				:>> closes = ProjectPhase::phaseD;
			}

			occurrence def KDPEn :> SpaceFlightKeyDecisionPoint {
				doc /* KDP En (Table 2-5). Expected maturity state: 'Program still meets Agency
				 * needs and is continuing to meet Agency commitments, as planned.' Applies only
				 * to single-project programs, informed by a PIR during Phase E; Figure 2-4
				 * numbers them KDP E2 and so on.
				 */
				:>> designation default = "KDP En";
			}

			occurrence def KDPF :> SpaceFlightKeyDecisionPoint {
				doc /* KDP F (Table 2-5). Expected maturity state: 'Project decommissioning is
				 * consistent with program objectives and project is ready for safe
				 * decommissioning of its assets and closeout of activities, including final
				 * delivery of all remaining project deliverables and disposal of its assets.'
				 * Informed by the DR.
				 */
				:>> designation = "KDP F";
				:>> closes = ProjectPhase::phaseE;
			}
		}
	}

	/* Sections 2.2.4, 2.2.5 and Tables 2-3 to 2-6: life-cycle and other reviews */

	action def SpaceFlightLifeCycleReview :> LifeCycleReview {
		doc /* A life-cycle review (LCR) of NPR 7120.5: 'Each program and project shall perform the
		 * LCRs in accordance with NPR 7123.1, applicable Center practices, and the requirements
		 * of this document.' (section 2.2.4). 'LCRs that occur at the end of each life-cycle
		 * phase are complete when the governing Program Management Council (PMC) and Decision
		 * Authority complete their assessment at the KDP and sign the Decision Memorandum.' The
		 * definitions of LifeCycleReviews document the objectives Tables 2-3 to 2-5 give each;
		 * NPR7123::ReviewCriteria holds the entrance and success criteria.
		 */
		attribute lifeCycle : LifeCycleKind[0..1];
		attribute requiresStandingReviewBoard : Boolean default false {
			doc /* True for the reviews section 2.2.5 has the SRB conduct. */
		}
		ref part standingReviewBoard : StandingReviewBoard[0..1] :> standingReviewBoards;
	}

	abstract action spaceFlightLifeCycleReviews : SpaceFlightLifeCycleReview[0..*] nonunique :> lifeCycleReviews;

	package LifeCycleReviews {
		doc /* The life-cycle reviews of the four life cycles, one definition each. The
		 * documentation of a definition opens with the 'LCR Objectives' Tables 2-3 to 2-5 give
		 * it. The reviews of a project and of a single-project program share one package.
		 */

		package UncoupledAndLooselyCoupledProgram {
			doc /* The life-cycle reviews of an uncoupled or loosely coupled program (Figure 2-2,
			 * Table 2-3).
			 */

			action def ProgramSRR :> SpaceFlightLifeCycleReview {
				doc /* System Requirements Review (Table 2-3). Objectives: 'To evaluate whether the
				 * program functional and performance requirements are properly formulated and
				 * correlated with the Agency and Mission Directorate strategic objectives and
				 * assess the credibility of the program’s estimated budget and schedule.'
				 * Informs KDP 0.
				 */
				:>> kind = ReviewKind::SRR;
				:>> lifeCycle = LifeCycleKind::uncoupledOrLooselyCoupledProgram;
				:>> requiresStandingReviewBoard = true;
			}

			action def ProgramSDR :> SpaceFlightLifeCycleReview {
				doc /* System Definition Review (Table 2-3). Objectives: 'To evaluate the proposed
				 * program requirements/architecture and allocation of requirements to initial
				 * projects, assess the adequacy of project pre-Formulation efforts, and
				 * determine whether the maturity of the program’s definition and associated
				 * plans are sufficient to begin implementation.' Informs KDP I.
				 */
				:>> kind = ReviewKind::SDR;
				:>> lifeCycle = LifeCycleKind::uncoupledOrLooselyCoupledProgram;
				:>> requiresStandingReviewBoard = true;
			}

			action def ProgramPIR :> SpaceFlightLifeCycleReview {
				doc /* Program Implementation Review (Table 2-3). Objectives: 'To evaluate the
				 * program’s continuing relevance to the Agency’s Strategic Plan, assess
				 * performance with respect to expectations, and determine the program’s ability
				 * to execute the implementation plan with acceptable risk within cost and
				 * schedule constraints.' Informs KDP II to KDP n; conducted as required by the
				 * Decision Authority (section 2.2.4.2).
				 */
				:>> kind = ReviewKind::PIR;
				:>> lifeCycle = LifeCycleKind::uncoupledOrLooselyCoupledProgram;
				:>> requiresStandingReviewBoard = true;
			}
		}

		package TightlyCoupledProgram {
			doc /* The life-cycle reviews of a tightly coupled program (Figure 2-3, Table 2-4). */

			action def TightlyCoupledSRR :> SpaceFlightLifeCycleReview {
				doc /* System Requirements Review (Table 2-4). Objectives: 'To evaluate whether the
				 * functional and performance requirements defined for the system are responsive
				 * to the Mission Directorate requirements on the program and its projects and
				 * represent achievable capabilities.' Informs KDP 0.
				 */
				:>> kind = ReviewKind::SRR;
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
				:>> requiresStandingReviewBoard = true;
			}

			action def TightlyCoupledSDR :> SpaceFlightLifeCycleReview {
				doc /* System Definition Review (Table 2-4). Objectives: 'To evaluate the
				 * credibility and responsiveness of the proposed program
				 * requirements/architecture to the Mission Directorate requirements and
				 * constraints, including available resources, and allocation of requirements to
				 * projects. To determine whether the maturity of the program’s mission/system
				 * definition and associated plans are sufficient to begin preliminary design.'
				 * Informs KDP 0.
				 */
				:>> kind = ReviewKind::SDR;
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
				:>> requiresStandingReviewBoard = true;
			}

			action def TightlyCoupledPDR :> SpaceFlightLifeCycleReview {
				doc /* Preliminary Design Review (Table 2-4). Objectives: 'To evaluate the
				 * completeness/consistency of the program’s preliminary design, including its
				 * projects, in meeting all requirements with appropriate margins, acceptable
				 * risk, and within cost and schedule constraints, and to determine the
				 * program’s readiness to proceed with the detailed design phase of the
				 * program.' Informs KDP I.
				 */
				:>> kind = ReviewKind::PDR;
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
				:>> requiresStandingReviewBoard = true;
			}

			action def TightlyCoupledCDR :> SpaceFlightLifeCycleReview {
				doc /* Critical Design Review (Table 2-4). Objectives: 'To evaluate the integrity of
				 * the program integrated design, including its projects and ground systems. To
				 * meet mission requirements with appropriate margins and acceptable risk within
				 * cost and schedule constraints. To determine if the integrated design is
				 * appropriately mature to continue with the final design and fabrication
				 * phase.' Informs KDP II.
				 */
				:>> kind = ReviewKind::CDR;
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
				:>> requiresStandingReviewBoard = true;
			}

			action def TightlyCoupledSIR :> SpaceFlightLifeCycleReview {
				doc /* System Integration Review (Table 2-4). Objectives: 'To evaluate the readiness
				 * of the program, including its projects and supporting infrastructure, to
				 * begin system AI&T with acceptable risk and within cost and schedule
				 * constraints.' Informs KDP II.
				 */
				:>> kind = ReviewKind::SIR;
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
				:>> requiresStandingReviewBoard = true;
			}

			action def TightlyCoupledORR :> SpaceFlightLifeCycleReview {
				doc /* Operational Readiness Review (Table 2-4). Objectives: 'To evaluate the
				 * readiness of the program, including its projects, ground systems, personnel,
				 * procedures, and user documentation. To operate the flight system and
				 * associated ground systems in compliance with program requirements and
				 * constraints during the operations phase.' Informs KDP III.
				 */
				:>> kind = ReviewKind::ORR;
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
				:>> requiresStandingReviewBoard = true;
			}

			action def TightlyCoupledFRROrMRR :> SpaceFlightLifeCycleReview {
				doc /* Flight Readiness Review or Mission Readiness Review (Table 2-4). Objectives:
				 * 'To evaluate the readiness of the program and its projects, ground systems,
				 * personnel, and procedures for a safe and successful launch and
				 * flight/mission.' Informs KDP III. A usage states `kind` as ReviewKind::FRR or
				 * ReviewKind::MRR.
				 */
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
			}

			action def TightlyCoupledPLAR :> SpaceFlightLifeCycleReview {
				doc /* Post-Launch Assessment Review (Table 2-4). Objectives: 'To evaluate the
				 * in-flight performance of the program and its projects. To determine the
				 * program's readiness to begin the operations phase of the life cycle and
				 * transfer responsibility to the operations organization.' A non-KDP mission
				 * operations review. Expected state: 'Project is ready to conduct mission
				 * operations with acceptable risk within Agency cost and schedule baselines.'
				 */
				:>> kind = ReviewKind::PLAR;
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
			}

			action def TightlyCoupledCERR :> SpaceFlightLifeCycleReview {
				doc /* Critical Events Readiness Review (Table 2-4). Objectives: 'To evaluate the
				 * readiness of the program and its projects to execute a critical event during
				 * the flight operations phase of the life cycle.' A non-KDP mission operations
				 * review. Expected state: 'Project is ready to conduct critical mission
				 * activity with acceptable risk.'
				 */
				:>> kind = ReviewKind::CERR;
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
			}

			action def TightlyCoupledPFAR :> SpaceFlightLifeCycleReview {
				doc /* Post-Flight Assessment Review (Table 2-4). Objectives: 'To evaluate how well
				 * mission objectives were met during a human space flight mission. To evaluate
				 * the status of the flight and ground systems, including the identification of
				 * any anomalies and their resolution.' A non-KDP mission operations review.
				 * Expected state: 'All anomalies that occurred in flight are identified, and
				 * actions necessary to mitigate or resolve these anomalies are in place.'
				 */
				:>> kind = ReviewKind::PFAR;
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
			}

			action def TightlyCoupledPIR :> SpaceFlightLifeCycleReview {
				doc /* Program Implementation Review (Table 2-4). Objectives: 'To evaluate the
				 * program's continuing relevance to the Agency's Strategic Plan, assess
				 * performance with respect to expectations, and determine the program's ability
				 * to execute the implementation plan with acceptable risk within cost and
				 * schedule constraints.' Informs KDP IV to KDP n-1.
				 */
				:>> kind = ReviewKind::PIR;
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
				:>> requiresStandingReviewBoard = true;
			}

			action def TightlyCoupledDR :> SpaceFlightLifeCycleReview {
				doc /* Decommissioning Review (Table 2-4). Objectives: 'To evaluate the readiness of
				 * the program and its projects to conduct closeout activities, including final
				 * delivery of all remaining program/project deliverables and safe
				 * decommissioning/disposal of space flight systems and other program/project
				 * assets.' Informs KDP n.
				 */
				:>> kind = ReviewKind::DR;
				:>> lifeCycle = LifeCycleKind::tightlyCoupledProgram;
			}
		}

		package ProjectAndSingleProjectProgram {
			doc /* The life-cycle reviews of a project or single-project program (Figures 2-4 and
			 * 2-5, Table 2-5).
			 */

			action def ProjectMCR :> SpaceFlightLifeCycleReview {
				doc /* Mission Concept Review (Table 2-5). Objectives: 'To evaluate the feasibility
				 * of the proposed mission concept(s) and its fulfillment of the program’s needs
				 * and objectives. To determine whether the maturity of the concept and
				 * associated planning are sufficient to begin Phase A.' Informs KDP A.
				 * Conducted with an independent assessment team rather than the SRB (section
				 * 2.2.5.a).
				 */
				:>> kind = ReviewKind::MCR;
			}

			action def ProjectSRR :> SpaceFlightLifeCycleReview {
				doc /* System Requirements Review (Table 2-5). Objectives: 'To evaluate whether the
				 * functional and performance requirements defined for the system are responsive
				 * to the program’s requirements on the project and represent achievable
				 * capabilities.' Informs KDP B.
				 */
				:>> kind = ReviewKind::SRR;
				:>> requiresStandingReviewBoard = true;
			}

			action def ProjectMDROrSDR :> SpaceFlightLifeCycleReview {
				doc /* Mission Definition Review or System Definition Review (Table 2-5).
				 * Objectives: 'To evaluate the credibility and responsiveness of the proposed
				 * mission/system architecture to the program requirements and constraints,
				 * including available resources. To determine whether the maturity of the
				 * project’s mission/system definition and associated plans are sufficient to
				 * begin Phase B.' Informs KDP B. A usage states `kind` as ReviewKind::MDR or
				 * ReviewKind::SDR.
				 */
				:>> requiresStandingReviewBoard = true;
			}

			action def ProjectPDR :> SpaceFlightLifeCycleReview {
				doc /* Preliminary Design Review (Table 2-5). Objectives: 'To evaluate the
				 * completeness/consistency of the planning, technical, cost, and schedule
				 * baselines developed during Formulation. To assess compliance of the
				 * preliminary design with applicable requirements and to determine if the
				 * project is sufficiently mature to begin Phase C.' Informs KDP C.
				 */
				:>> kind = ReviewKind::PDR;
				:>> requiresStandingReviewBoard = true;
			}

			action def ProjectCDR :> SpaceFlightLifeCycleReview {
				doc /* Critical Design Review (Table 2-5). Objectives: 'To evaluate the integrity of
				 * the project design and its ability to meet mission requirements with
				 * appropriate margins and acceptable risk within defined project constraints,
				 * including available resources. To determine if the design is appropriately
				 * mature to continue with the final design and fabrication phase.' Informs KDP
				 * D.
				 */
				:>> kind = ReviewKind::CDR;
				:>> requiresStandingReviewBoard = true;
			}

			action def ProjectPRR :> SpaceFlightLifeCycleReview {
				doc /* Production Readiness Review (Table 2-5). Objectives: 'To evaluate the
				 * readiness of system developer(s) to produce the required number of systems
				 * within defined project constraints for projects developing multiple similar
				 * flight or ground support systems. To evaluate the degree to which the
				 * production plans meet the system’s operational support requirements.' Informs
				 * KDP D. Needed only when there are multiple copies of systems (Figure 2-5).
				 */
				:>> kind = ReviewKind::PRR;
			}

			action def ProjectSIR :> SpaceFlightLifeCycleReview {
				doc /* System Integration Review (Table 2-5). Objectives: 'To evaluate the readiness
				 * of the project and associated supporting infrastructure to begin system AI&T,
				 * evaluate whether the remaining project development can be completed within
				 * available resources, and determine if the project is sufficiently mature to
				 * begin Phase D.' Informs KDP D.
				 */
				:>> kind = ReviewKind::SIR;
				:>> requiresStandingReviewBoard = true;
			}

			action def ProjectORR :> SpaceFlightLifeCycleReview {
				doc /* Operational Readiness Review (Table 2-5). Objectives: 'To evaluate the
				 * readiness of the project to operate the flight system and associated ground
				 * system(s) in compliance with defined project requirements and constraints
				 * during the operations/sustainment phase of the project life cycle.' Informs
				 * KDP E.
				 */
				:>> kind = ReviewKind::ORR;
				:>> requiresStandingReviewBoard = true;
			}

			action def ProjectMRROrFRR :> SpaceFlightLifeCycleReview {
				doc /* Mission Readiness Review or Flight Readiness Review (Table 2-5). Objectives:
				 * 'To evaluate the readiness of the project and all project and supporting
				 * systems for a safe and successful launch and flight/mission.' Informs KDP E.
				 * A usage states `kind` as ReviewKind::MRR or ReviewKind::FRR.
				 */
			}

			action def SingleProjectProgramPIR :> SpaceFlightLifeCycleReview {
				doc /* Program Implementation Review (Table 2-5). Objectives: 'To evaluate the
				 * program’s continuing relevance to the Agency’s Strategic Plan, assess
				 * performance with respect to expectations, and determine the program’s ability
				 * to execute the implementation plan with acceptable risk within cost and
				 * schedule constraints.' Informs KDP En; applies only to single-project
				 * programs.
				 */
				:>> kind = ReviewKind::PIR;
				:>> requiresStandingReviewBoard = true;
			}

			action def ProjectPLAR :> SpaceFlightLifeCycleReview {
				doc /* Post-Launch Assessment Review (Table 2-5). Objectives: 'To evaluate in-flight
				 * performance of the flight system early in the mission and determine whether
				 * the project is sufficiently prepared to begin Phase E.' A non-KDP review.
				 * Expected state: 'Project is ready to conduct mission operations with
				 * acceptable risk within ABC.'
				 */
				:>> kind = ReviewKind::PLAR;
			}

			action def ProjectCERR :> SpaceFlightLifeCycleReview {
				doc /* Critical Events Readiness Review (Table 2-5). Objectives: 'To evaluate the
				 * readiness of the project and the flight system for execution of a critical
				 * event during the flight operations phase of the life cycle.' A non-KDP
				 * review. Expected state: 'Project is ready to conduct critical mission
				 * activity with acceptable risk.'
				 */
				:>> kind = ReviewKind::CERR;
			}

			action def ProjectPFAR :> SpaceFlightLifeCycleReview {
				doc /* Post-Flight Assessment Review (Table 2-5). Objectives: 'To evaluate how well
				 * mission objectives were met during a human space flight mission and to
				 * evaluate the status of the returned vehicle.' A non-KDP review. Expected
				 * state: 'All anomalies that occurred in flight are identified. Actions
				 * necessary to mitigate or resolve these anomalies are in place.'
				 */
				:>> kind = ReviewKind::PFAR;
			}

			action def ProjectDR :> SpaceFlightLifeCycleReview {
				doc /* Decommissioning Review (Table 2-5). Objectives: 'To evaluate the readiness of
				 * the project to conduct closeout activities including final delivery of all
				 * remaining project deliverables and safe decommissioning of space flight
				 * systems and other project assets. To determine if the project is
				 * appropriately prepared to begin Phase F.' Informs KDP F.
				 */
				:>> kind = ReviewKind::DR;
			}

			action def ProjectDRR :> SpaceFlightLifeCycleReview {
				doc /* Disposal Readiness Review (Table 2-5). Objectives: 'To evaluate the readiness
				 * of the project and the flight system for execution of the spacecraft disposal
				 * event.' A non-KDP review. Expected state: 'Project ready to conduct disposal
				 * activity with acceptable risk.'
				 */
				:>> kind = ReviewKind::DRR;
			}
		}
	}

	abstract action def OtherReview :> Action {
		doc /* One of the other reviews of Table 2-6, which the life-cycle figures draw beside the
		 * life-cycle reviews.
		 */
	}

	abstract action otherReviews : OtherReview[0..*] nonunique :> actions;

	action def SystemAcceptanceReview :> OtherReview {
		doc /* System Acceptance Review (SAR) (Table 2-6). Objective: 'To evaluate whether a
		 * specific end item is sufficiently mature to be shipped from the supplier to its
		 * designated operational facility or launch site.'
		 */
	}

	action def SafetyAndMissionSuccessReview :> OtherReview {
		doc /* Safety and Mission Success Review (SMSR) (Table 2-6). Objective: 'To prepare Agency
		 * safety, engineering, and health and medical management to participate in program
		 * final readiness reviews preceding flights or launches, including experimental/test
		 * launch vehicles or other reviews as determined by the Chief, Safety and Mission
		 * Assurance.'
		 */
	}

	action def LaunchReadinessReview :> OtherReview {
		doc /* Launch Readiness Review (LRR) (Table 2-6). Objective: 'To evaluate a program/project
		 * and its ground, hardware, and software systems for readiness for launch.'
		 */
	}

	/* Appendix C: the requirements and the compliance matrix */

	requirement def PMRequirement :> RequirementCheck {
		doc /* One row of Table C-1: a requirement of NPR 7120.5 or a required product of the
		 * Appendix I tables. The documentation of each definition in PMRequirements is the
		 * 'NPR 7120.5 Requirement Statement' column; `id` is the 'Para #' column, `requirementOwner` the
		 * 'Requirement Owner', `tailoringDelegated` the 'Delegated' column ('"Yes" ... indicates
		 * that tailoring authority has been delegated by the requirement owner', section
		 * C.1.3.2) and the three `appliesTo` attributes the 'MDAA', 'CD' and 'PM' columns ('An
		 * "A" in the column indicates applicability', section C.1.3.3). A program or project
		 * states its compliance with each by annotating a usage with `@PMCompliance`.
		 */
		attribute id : String;
		attribute requirementOwner : String;
		attribute tailoringDelegated : Boolean;
		attribute appliesToMDAA : Boolean;
		attribute appliesToCenterDirector : Boolean;
		attribute appliesToProgramOrProjectManager : Boolean;
	}

	abstract requirement pmRequirements : PMRequirement[0..*] nonunique :> requirementChecks;

	package PMRequirements {
		doc /* The 241 rows of Table C-1, one definition each: the 55 requirement statements of
		 * chapters 2 and 3, named by paragraph, and the 186 required products of the Appendix I
		 * tables, in one package per table. A product row's statement is the product's name
		 * with the baseline point and the governing directive Table C-1 prints in brackets; its
		 * short name gives the table, a group letter (P program or single-project program
		 * products, H Headquarters and program products, T technical products, M management,
		 * planning and control products, C control plans) and the row number. 'I-Table products
		 * marked as "Best Practice" (BP) are not included in the Compliance Matrix', which is
		 * why row numbers skip, and the two 'Project Baselines' heading rows, which Table C-1
		 * marks N/A, are not modelled. Table C-1 marks the PM column of paragraph 2.2.5.a 'A1'
		 * without printing a note 1 for it; the library reads it as applicable.
		 */

		requirement def <'2.1.1.2'> Req2_1_1_2 :> PMRequirement {
			doc /* Regardless of the structure of a program or project meeting the criteria of
			 * Section P.2, this NPR shall apply to the full scope of the program or project and
			 * all the activities under it.
			 */
			:>> id = "2.1.1.2";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.1.3.1'> Req2_1_3_1 :> PMRequirement {
			doc /* Projects are Category 1, 2, or 3 and shall be assigned to a category based
			 * initially on: (1) the project life-cycle cost (LCC) estimate, the inclusion of
			 * significant radioactive material, and whether or not the system being developed
			 * is for human space flight; and (2) the priority level, which is related to the
			 * importance of the activity to NASA, the extent of international participation (or
			 * joint effort with other government agencies), the degree of uncertainty
			 * surrounding the application of new or untested technologies, and
			 * spacecraft/payload development risk classification.
			 */
			:>> id = "2.1.3.1";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = false;
		}

		requirement def <'2.1.3.2'> Req2_1_3_2 :> PMRequirement {
			doc /* For Category 1 projects, the assignment of a project to a Center or implementing
			 * organization shall be with the concurrence of the NASA AA.
			 */
			:>> id = "2.1.3.2";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = false;
		}

		requirement def <'2.1.4.1'> Req2_1_4_1 :> PMRequirement {
			doc /* Programs and projects with a LCC or initial capability cost (see Section
			 * 2.4.1.3.b) greater than $250M shall be managed by program and project managers
			 * who have been certified in compliance with Office of Management and Budget
			 * (OMB)’s promulgated Federal acquisition program/project management certification
			 * requirements.
			 */
			:>> id = "2.1.4.1";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = false;
		}

		requirement def <'2.2.1'> Req2_2_1 :> PMRequirement {
			doc /* Program and project managers shall follow their appropriate life cycle as
			 * identified in each program and project respective life-cycle figure. Life cycles
			 * include life-cycle phases, gates, and major events; performing KDPs and major
			 * life-cycle reviews (LCRs); developing principal documents that govern the conduct
			 * of each phase; and re-entering the life cycle when program or project changes
			 * warrant such action.
			 */
			:>> id = "2.2.1";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.2'> Req2_2_2 :> PMRequirement {
			doc /* Program and project managers shall organize the work required for each phase
			 * using a product-based WBS developed in accordance with the Program and Project
			 * Plan templates (appendices G and H).
			 */
			:>> id = "2.2.2";
			:>> requirementOwner = "OCFO";
			:>> tailoringDelegated = true;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.3'> Req2_2_3 :> PMRequirement {
			doc /* The documents shown on the life-cycle figures and described below shall be
			 * prepared in accordance with the templates in appendices D, E, F, G, H, and J
			 */
			:>> id = "2.2.3";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.4'> Req2_2_4 :> PMRequirement {
			doc /* Each program and project shall perform the LCRs in accordance with NPR 7123.1,
			 * applicable Center practices, and the requirements of this document.
			 */
			:>> id = "2.2.4";
			:>> requirementOwner = "OCE";
			:>> tailoringDelegated = true;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.5'> Req2_2_5 :> PMRequirement {
			doc /* Program or project managers and an independent Standing Review Board (SRB) shall
			 * conduct the System Requirements Review (SRR), System Definition Review (SDR)/
			 * Mission Definition Review (MDR), Preliminary Design Review (PDR), Critical Design
			 * Review (CDR), System Integration Review (SIR), Operational Readiness Review
			 * (ORR), and PIR LCRs in figures 2-2, 2-3, 2-4, and 2-5.
			 */
			:>> id = "2.2.5";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.5.a'> Req2_2_5_a :> PMRequirement {
			doc /* The program and project managers, or responsible pre-formulation office as
			 * determined by the MDAA, and an independent assessment team shall conduct a
			 * Mission Concept Review (MCR). The review is to be consistent with NPR 7123.1D and
			 * the scope contained in the Pre-Formulation Approval Letter (PFAL) per appendix J
			 * Pre-Formulation Approval Letter Template, and any other parameters specified by
			 * the MDAA and noted in the final PFAL issued to the program or project, or
			 * responsible pre-formulation office as determined by the MDAA.
			 */
			:>> id = "2.2.5.a";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.5.1'> Req2_2_5_1 :> PMRequirement {
			doc /* The Conflict of Interest (COI) procedures detailed in the NASA Standing Review
			 * Board Handbook shall be strictly adhered to.
			 */
			:>> id = "2.2.5.1";
			:>> requirementOwner = "OGC";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = true;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.5.2'> Req2_2_5_2 :> PMRequirement {
			doc /* The portion of the LCRs conducted by the SRB and the MCR independent assessment
			 * team shall be convened by the Convening Authorities in accordance with Table 2-2.
			 * The scope and requirements for this review will be documented in a Terms of
			 * Reference (ToR), for which there is a template in the NASA Standing Review Board
			 * Handbook.
			 */
			:>> id = "2.2.5.2";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = true;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.5.3'> Req2_2_5_3 :> PMRequirement {
			doc /* The program or project manager, the SRB chair, and the Center Director (or
			 * designated Engineering Technical Authority (ETA) representative) shall mutually
			 * assess the program’s or project’s expected readiness for the LCR and report any
			 * disagreements to the Decision Authority for final decision.
			 */
			:>> id = "2.2.5.3";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = true;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.6'> Req2_2_6 :> PMRequirement {
			doc /* In preparation for these LCRs, the program or project manager shall generate the
			 * appropriate documentation per the Appendix I tables of this document, NPR 7123.1,
			 * and Center practices, as necessary, to demonstrate that the program’s or
			 * project’s definition and associated plans are sufficiently mature to execute the
			 * follow-on phase(s) with acceptable technical, safety, and programmatic risk.
			 */
			:>> id = "2.2.6";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.8'> Req2_2_8 :> PMRequirement {
			doc /* Projects, single-project programs (and other programs at the discretion of the
			 * MDAA) with a life-cycle cost (LCC) or initial capability cost (see Section
			 * 2.4.1.3.b) estimated to be greater than $250M shall perform earned value
			 * management (EVM) and comply with EIA-748, Earned Value Management Systems for all
			 * portions of work including in-house and contracted portions of the project.
			 */
			:>> id = "2.2.8";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.8.1'> Req2_2_8_1 :> PMRequirement {
			doc /* Program and project managers with programs and projects subject to EVM shall
			 * utilize the NASA EVM Capability Process for in-house work.
			 */
			:>> id = "2.2.8.1";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.8.2'> Req2_2_8_2 :> PMRequirement {
			doc /* EVM system requirements for contracted work shall be applied to suppliers in
			 * accordance with the NASA Federal Acquisition Regulation (FAR) Supplement,
			 * independent of phase and the $250M threshold
			 * (https://www.hq.nasa.gov/office/procurement/regs/NFS.pdf.).
			 */
			:>> id = "2.2.8.2";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.8.3'> Req2_2_8_3 :> PMRequirement {
			doc /* Mission Directorates shall conduct an IBR in preparation for KDP C and for major
			 * changes that significantly impact the cost and schedule baseline.
			 */
			:>> id = "2.2.8.3";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.8.4'> Req2_2_8_4 :> PMRequirement {
			doc /* EVMS surveillance shall be conducted on contracts and programs and projects with
			 * in-house work to ensure continued compliance with EIA-748, Earned Value
			 * Management Systems.
			 */
			:>> id = "2.2.8.4";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.10'> Req2_2_10 :> PMRequirement {
			doc /* Program and project managers shall complete and maintain a Compliance Matrix (see
			 * Appendix C) for this NPR and attach it to the Formulation Agreement for projects
			 * in Formulation and/or the Program or Project Plan.
			 */
			:>> id = "2.2.10";
			:>> requirementOwner = "OCE";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.2.11'> Req2_2_11 :> PMRequirement {
			doc /* Single-project programs and projects shall develop a Project Protection Plan that
			 * addresses NASA-STD-1006, Space System Protection Standard in accordance with NPR
			 * 1058.1, Enterprise Protection Program.
			 */
			:>> id = "2.2.11";
			:>> requirementOwner = "OCE";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.3.1'> Req2_3_1 :> PMRequirement {
			doc /* Each program and project shall have a Decision Authority the Agency’s responsible
			 * individual who determines whether and how the program or project proceeds through
			 * the life cycle and the key program or project cost, schedule, and content
			 * parameters that govern the remaining life-cycle activities.
			 */
			:>> id = "2.3.1";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = false;
		}

		requirement def <'2.3.1.1'> Req2_3_1_1 :> PMRequirement {
			doc /* The MDAA shall inform the NASA AA and Administrator via email on all Agency
			 * Baseline Commitments (ABCs) per the following: inform the NASA AA on ABCs for
			 * single-project programs and projects with a LCC or initial capability cost (see
			 * Section 2.4.1.3.b) greater than $250M; and inform the NASA Administrator on ABCs
			 * for all single-project programs and projects with a LCC or initial capability
			 * cost greater than $1B and all Category 1 projects. (See Section 2.4.1.5 for more
			 * information on ABCs.)
			 */
			:>> id = "2.3.1.1";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = false;
		}

		requirement def <'2.3.2'> Req2_3_2 :> PMRequirement {
			doc /* Each program and project shall have a governing PMC. */
			:>> id = "2.3.2";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = false;
		}

		requirement def <'2.3.4'> Req2_3_4 :> PMRequirement {
			doc /* The Center Director (or designee) shall oversee programs and projects usually
			 * through the CMC, which monitors and evaluates all program and project work
			 * (regardless of category) executed at that Center.
			 */
			:>> id = "2.3.4";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = true;
			:>> appliesToProgramOrProjectManager = false;
		}

		requirement def <'2.3.5'> Req2_3_5 :> PMRequirement {
			doc /* Following each LCR, the independent SRB chair and the program or project manager
			 * shall brief the applicable management councils on the results of the LCR to
			 * support the councils’ assessments.
			 */
			:>> id = "2.3.5";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = true;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.1'> Req2_4_1 :> PMRequirement {
			doc /* The decisions by the Decision Authority on whether and how the program or project
			 * proceeds into the next phase shall be summarized and recorded in the Decision
			 * Memorandum signed at the conclusion of the governing PMC by all parties with
			 * supporting responsibilities, accepting their respective roles.
			 */
			:>> id = "2.4.1";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = false;
		}

		requirement def <'2.4.1.1'> Req2_4_1_1 :> PMRequirement {
			doc /* The Decision Memorandum shall describe the constraints and parameters within
			 * which the Agency, the program manager, and the project manager will operate; the
			 * extent to which changes in plans may be made without additional approval; any
			 * additional actions that came out of the KDP; and the supporting data (i.e., the
			 * cost and schedule datasheet) that provide further details.
			 */
			:>> id = "2.4.1.1";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.1.2'> Req2_4_1_2 :> PMRequirement {
			doc /* A divergence from the Management Agreement that any party identifies as
			 * significant shall be accompanied by an amendment to the Decision Memorandum.
			 */
			:>> id = "2.4.1.2";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.1.3'> Req2_4_1_3 :> PMRequirement {
			doc /* During Formulation, the Decision Memorandum shall establish a target LCC or
			 * initial capability cost range (and schedule range, if applicable) as well as the
			 * Management Agreement addressing the schedule and resources required to complete
			 * Formulation.
			 */
			:>> id = "2.4.1.3";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.1.3.a'> Req2_4_1_3_a :> PMRequirement {
			doc /* For single-project programs and projects with a LCC or initial capability cost
			 * greater than or equal to $1B, the Decision Memorandum shall establish a high and
			 * low value for cost and schedule with the corresponding JCL value at KDP B.
			 */
			:>> id = "2.4.1.3.a";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.1.5'> Req2_4_1_5 :> PMRequirement {
			doc /* All single-project program managers and project managers shall document the
			 * Agency’s LCC estimate or initial capability cost estimate and other parameters in
			 * the Decision Memorandum for Implementation (KDP C), and this becomes the ABC.
			 */
			:>> id = "2.4.1.5";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.1.5.a'> Req2_4_1_5_a :> PMRequirement {
			doc /* For all single-project programs and projects with a definite Phase E end point,
			 * the Agency’s LCC estimate and other parameters shall become the ABC.
			 */
			:>> id = "2.4.1.5.a";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.1.5.b'> Req2_4_1_5_b :> PMRequirement {
			doc /* For single-project programs and projects that plan continuing operations and
			 * production, including integration of capability upgrades, with an unspecified
			 * Phase E end point, the initial capability cost estimate and other parameters
			 * shall become the ABC.
			 */
			:>> id = "2.4.1.5.b";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.1.7'> Req2_4_1_7 :> PMRequirement {
			doc /* Tightly coupled programs shall document their LCC estimate in accordance with the
			 * scope defined in the FAD or PCA, and other parameters in their Decision
			 * Memorandum at KDP I and update it at subsequent KDPs.
			 */
			:>> id = "2.4.1.7";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.1.8'> Req2_4_1_8 :> PMRequirement {
			doc /* Programs or projects shall be rebaselined when: (1) the estimated development
			 * cost exceeds the ABC development cost by 30 percent or more (for projects over
			 * $250M, also that Congress has reauthorized the project); (2) the NASA AA judges
			 * that events external to the Agency make a rebaseline appropriate; or (3) the NASA
			 * AA judges that the program or project scope defined in the ABC has been changed
			 * or the project has been interrupted.
			 */
			:>> id = "2.4.1.8";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.2'> Req2_4_2 :> PMRequirement {
			doc /* The program or project shall document the basis of estimate (BOE) for cost
			 * estimates and planned schedules in retrievable program or project records.
			 */
			:>> id = "2.4.2";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.3.1.a'> Req2_4_3_1_a :> PMRequirement {
			doc /* Single-project programs with an estimated LCC under $1B and projects with an
			 * estimated LCC greater than $250M and under $1B shall provide a range of cost and
			 * a range for schedule, each range (with confidence levels identified for the low
			 * and high values of the range) established by a probabilistic analysis and based
			 * on identified resources and associated uncertainties by fiscal year.
			 */
			:>> id = "2.4.3.1.a";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.3.1.b'> Req2_4_3_1_b :> PMRequirement {
			doc /* Single-project programs and projects with an estimated LCC greater than or equal
			 * to $1B shall develop a JCL and provide a high and low value for cost and schedule
			 * with the corresponding JCL value (e.g., 50 percent, 70 percent).
			 */
			:>> id = "2.4.3.1.b";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.3.2'> Req2_4_3_2 :> PMRequirement {
			doc /* At KDP C, single-project programs (regardless of LCC) and projects with an
			 * estimated LCC greater than $250M shall develop a cost-loaded schedule and perform
			 * a risk-informed probabilistic analysis that produces a JCL.
			 */
			:>> id = "2.4.3.2";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.3.3'> Req2_4_3_3 :> PMRequirement {
			doc /* At CDR, single-project programs and projects with an estimated LCC greater than
			 * or equal to $1B shall update their KDP C JCL and communicate the updated JCL
			 * values for the ABC and Management Agreement to the APMC for informational
			 * purposes.
			 */
			:>> id = "2.4.3.3";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.3.4'> Req2_4_3_4 :> PMRequirement {
			doc /* At KDP D, single-project programs and projects with an estimated LCC greater than
			 * or equal to $1B shall update their JCL if current reported development costs have
			 * exceeded the development ABC cost by 5 percent or more and document the updated
			 * JCL values for the ABC and Management Agreement in the KDP D Decision Memorandum.
			 */
			:>> id = "2.4.3.4";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.3.5'> Req2_4_3_5 :> PMRequirement {
			doc /* When a single-project program (regardless of LCC) or project with an estimated
			 * LCC greater than $250M is rebaselined, a JCL shall be calculated and evaluated as
			 * a part of the rebaselining approval process.
			 */
			:>> id = "2.4.3.5";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'2.4.4.1'> Req2_4_4_1 :> PMRequirement {
			doc /* At KDP B, Mission Directorates shall plan and budget single-project programs and
			 * projects with an estimated LCC greater than or equal to $1B based on a 70 percent
			 * JCL or as approved by the Decision Authority.
			 */
			:>> id = "2.4.4.1";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = false;
		}

		requirement def <'2.4.4.2'> Req2_4_4_2 :> PMRequirement {
			doc /* At KDP C, Mission Directorates shall plan and budget single-project programs
			 * (regardless of LCC) and projects with an estimated LCC greater than $250M based
			 * on a 70 percent JCL or as approved by the Decision Authority.
			 */
			:>> id = "2.4.4.2";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = false;
		}

		requirement def <'2.4.4.3'> Req2_4_4_3 :> PMRequirement {
			doc /* At KDP B and KDP C, any JCL approved by the Decision Authority at less than 70
			 * percent shall be justified and documented in a Decision Memorandum.
			 */
			:>> id = "2.4.4.3";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = false;
		}

		requirement def <'2.4.4.4'> Req2_4_4_4 :> PMRequirement {
			doc /* At KDP C, Mission Directorates shall ensure funding for single-project programs
			 * (regardless of LCC) and projects with an estimated LCC greater than $250M is
			 * consistent with the Management Agreement and in no case less than the equivalent
			 * of a 50 percent JCL or as approved by the Decision Authority.
			 */
			:>> id = "2.4.4.4";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = false;
		}

		requirement def <'2.4.4.5'> Req2_4_4_5 :> PMRequirement {
			doc /* At KDP C, any funding approved by the Decision Authority that is inconsistent
			 * with the Management Agreement or less than 50 percent JCL shall be justified and
			 * documented in a Decision Memorandum.
			 */
			:>> id = "2.4.4.5";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = false;
		}

		requirement def <'2.4.5'> Req2_4_5 :> PMRequirement {
			doc /* Tightly coupled, loosely coupled, and uncoupled programs shall provide analysis
			 * of the program’s risk posture to the governing PMC as each new project reaches
			 * KDP B and C or when a project’s ABC is rebaselined.
			 */
			:>> id = "2.4.5";
			:>> requirementOwner = "OCFO-SID";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'3.3.1'> Req3_3_1 :> PMRequirement {
			doc /* Programs and projects shall follow the Technical Authority (TA) process
			 * established in this Section 3.3.
			 */
			:>> id = "3.3.1";
			:>> requirementOwner = "OCE";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = true;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'3.4.1'> Req3_4_1 :> PMRequirement {
			doc /* Programs and projects shall follow the Formal Dissent process in this Section
			 * 3.4.
			 */
			:>> id = "3.4.1";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = true;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'3.5.1'> Req3_5_1 :> PMRequirement {
			doc /* Programs and projects shall follow the tailoring process in this Section 3.5. */
			:>> id = "3.5.1";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = true;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'3.5.5'> Req3_5_5 :> PMRequirement {
			doc /* A request for a permanent change to a prescribed requirement in an Agency or
			 * Center document that is applicable to all programs and projects shall be
			 * submitted as a “change request” to the office responsible for the requirement
			 * policy document unless formally delegated elsewhere.
			 */
			:>> id = "3.5.5";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = true;
			:>> appliesToCenterDirector = true;
			:>> appliesToProgramOrProjectManager = true;
		}

		requirement def <'3.6.1'> Req3_6_1 :> PMRequirement {
			doc /* Center Directors negotiating reimbursable space flight work with another agency
			 * shall propose NPR 7120.5 as the basis by which it will perform the space flight
			 * work.
			 */
			:>> id = "3.6.1";
			:>> requirementOwner = "NASA AA";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = true;
			:>> appliesToProgramOrProjectManager = false;
		}

		requirement def <'3.7.1'> Req3_7_1 :> PMRequirement {
			doc /* Each program and project shall perform and document an assessment to determine an
			 * approach that maximizes the use of SI.
			 */
			:>> id = "3.7.1";
			:>> requirementOwner = "OCE";
			:>> tailoringDelegated = false;
			:>> appliesToMDAA = false;
			:>> appliesToCenterDirector = false;
			:>> appliesToProgramOrProjectManager = true;
		}

		package TableI1 {
			doc /* The required products of Table I-1, Uncoupled and Loosely Coupled Program
			 * Milestone Products and Control Plans Maturity Matrix, as Table C-1 lists them.
			 */

			requirement def <'I-1.P.1'> Product1 :> PMRequirement {
				doc /* FAD [Baseline at approval for Formulation] [Required per NPR 7120.5] */
				:>> id = "Table I-1 P.1";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.P.2'> Product2 :> PMRequirement {
				doc /* PCA [Baseline at KDP I] [Required per NPR 7120.5] */
				:>> id = "Table I-1 P.2";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = false;
			}

			requirement def <'I-1.P.3'> Product3 :> PMRequirement {
				doc /* Program Plan [Baseline at SDR] [Required per NPR 7120.5] */
				:>> id = "Table I-1 P.3";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = true;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.P.3.a'> Product3a :> PMRequirement {
				doc /* Mission Directorate requirements and constraints [Baseline at SRR] [Required
				 * per NPR 7123.1]
				 */
				:>> id = "Table I-1 P.3.a";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.P.3.b'> Product3b :> PMRequirement {
				doc /* Traceability of program-level requirements on projects to the Agency
				 * strategic goals and Mission Directorate requirements and constraints
				 * [Baseline at SDR] [Required per NPR 7123.1]
				 */
				:>> id = "Table I-1 P.3.b";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.P.3.c'> Product3c :> PMRequirement {
				doc /* Documentation of driving ground rules and assumptions on the program
				 * [Baseline at SDR] [Required per NPR 7120.5]
				 */
				:>> id = "Table I-1 P.3.c";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.P.4'> Product4 :> PMRequirement {
				doc /* Interagency and international agreements [Baseline at SDR] */
				:>> id = "Table I-1 P.4";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.P.5'> Product5 :> PMRequirement {
				doc /* ASM Decision Memorandum [additional information in NPD 1000.5] */
				:>> id = "Table I-1 P.5";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.P.6'> Product6 :> PMRequirement {
				doc /* Risk mitigation plans and resources for significant risks [Required per NPR
				 * 7120.5]
				 */
				:>> id = "Table I-1 P.6";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.P.7'> Product7 :> PMRequirement {
				doc /* Documented Cost and Schedule Baselines [Baseline at SDR] [Required per NPR
				 * 7120.5]
				 */
				:>> id = "Table I-1 P.7";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.P.8'> Product8 :> PMRequirement {
				doc /* Documentation of Basis of Estimate (cost and schedule) [Baseline at SDR]
				 * [Required per NPR 7120.5]
				 */
				:>> id = "Table I-1 P.8";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.P.9'> Product9 :> PMRequirement {
				doc /* Documentation of performance against plan/baseline, including status/closure
				 * of formal actions from previous KDP [Required per NPR 7120.5]
				 */
				:>> id = "Table I-1 P.9";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.P.10'> Product10 :> PMRequirement {
				doc /* Industrial Base and Supply Chain Risk Management (SCRM) Strategy and Status
				 * [Baseline at SDR] [Required per NPR 8735.2]
				 */
				:>> id = "Table I-1 P.10";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.C.1'> ControlPlan1 :> PMRequirement {
				doc /* Technical, Schedule, and Cost Control Plan [Baseline at SDR] [Required per
				 * NPR 7120.5]
				 */
				:>> id = "Table I-1 C.1";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.C.2'> ControlPlan2 :> PMRequirement {
				doc /* Safety and Mission Assurance Plan [Baseline at SDR] [Required per NPRs 8705.2
				 * and 8705.4]
				 */
				:>> id = "Table I-1 C.2";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.C.3'> ControlPlan3 :> PMRequirement {
				doc /* Risk Management Plan [Baseline at SDR] */
				:>> id = "Table I-1 C.3";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.C.4'> ControlPlan4 :> PMRequirement {
				doc /* Acquisition Strategy [Baseline at SDR] [Required per NPD 1000.5] */
				:>> id = "Table I-1 C.4";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.C.6'> ControlPlan6 :> PMRequirement {
				doc /* Systems Engineering Management Plan [Baseline at SDR] [Required per NPR
				 * 7123.1]
				 */
				:>> id = "Table I-1 C.6";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.C.7'> ControlPlan7 :> PMRequirement {
				doc /* System Security Plan [Baseline at SDR] [Required per NPR 2810.1] */
				:>> id = "Table I-1 C.7";
				:>> requirementOwner = "OCIO";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.C.8'> ControlPlan8 :> PMRequirement {
				doc /* Review Plan [Baseline at SRR] [Required per NPR 7120.5] */
				:>> id = "Table I-1 C.8";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.C.9'> ControlPlan9 :> PMRequirement {
				doc /* NEPA Compliance Plan [Baseline at SDR] [Required per NPR 8580.1] */
				:>> id = "Table I-1 C.9";
				:>> requirementOwner = "OSI-EMD";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.C.10'> ControlPlan10 :> PMRequirement {
				doc /* Configuration Management Plan [Baseline at SDR] [Required per NPR 7120.5;
				 * additional information in NPR 7123.1 and SAE/EIA 649]
				 */
				:>> id = "Table I-1 C.10";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.C.11'> ControlPlan11 :> PMRequirement {
				doc /* Security Plan [Baseline at SDR] [Required per NPR 1040.1 and NPR 1600.1] */
				:>> id = "Table I-1 C.11";
				:>> requirementOwner = "OPS";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.C.12'> ControlPlan12 :> PMRequirement {
				doc /* Technology Transfer (formerly Export) Control Plan [Baseline at SDR]
				 * [Required per NPR 2190.1]
				 */
				:>> id = "Table I-1 C.12";
				:>> requirementOwner = "OIIR";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-1.C.15'> ControlPlan15 :> PMRequirement {
				doc /* Quality Assurance Surveillance Plan [Baseline at SDR] [Required per NPR
				 * 8735.2 and NASA FAR Supplement part 1837.604]
				 */
				:>> id = "Table I-1 C.15";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}
		}

		package TableI2 {
			doc /* The required products of Table I-2, Tightly Coupled Program Milestone Products
			 * Maturity Matrix, as Table C-1 lists them.
			 */

			requirement def <'I-2.P.1'> Product1 :> PMRequirement {
				doc /* FAD [Baseline at approval for Formulation] [Required per NPR 7120.5] */
				:>> id = "Table I-2 P.1";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-2.P.2'> Product2 :> PMRequirement {
				doc /* PCA [Baseline at PDR] [Required per NPR 7120.5] */
				:>> id = "Table I-2 P.2";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = false;
			}

			requirement def <'I-2.P.3'> Product3 :> PMRequirement {
				doc /* Program Plan [Baseline at SDR] [Required per NPR 7120.5] */
				:>> id = "Table I-2 P.3";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = true;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-2.P.3.a'> Product3a :> PMRequirement {
				doc /* Mission Directorate requirements and constraints [Baseline at SRR] [Required
				 * per NPR 7123.1]
				 */
				:>> id = "Table I-2 P.3.a";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-2.P.3.b'> Product3b :> PMRequirement {
				doc /* Traceability of program-level requirements on projects to the Agency
				 * strategic goals and Mission Directorate requirements and constraints
				 * [Baseline at SDR] [Required per NPR 7123.1]
				 */
				:>> id = "Table I-2 P.3.b";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-2.P.3.c'> Product3c :> PMRequirement {
				doc /* Documentation of driving ground rules and assumptions on the program
				 * [Baseline at SDR] [Required per NPR 7120.5]
				 */
				:>> id = "Table I-2 P.3.c";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-2.P.4'> Product4 :> PMRequirement {
				doc /* Interagency and international agreements [Baseline at SDR] */
				:>> id = "Table I-2 P.4";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-2.P.5'> Product5 :> PMRequirement {
				doc /* ASM Decision Memorandum [additional information in NPD 1000.5] */
				:>> id = "Table I-2 P.5";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-2.P.6'> Product6 :> PMRequirement {
				doc /* Risk mitigation plans and resources for significant risks [Required per NPR
				 * 7120.5]
				 */
				:>> id = "Table I-2 P.6";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-2.P.7'> Product7 :> PMRequirement {
				doc /* Documented Cost and Schedule Baselines [Baseline at PDR] [Required per NPR
				 * 7120.5]
				 */
				:>> id = "Table I-2 P.7";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-2.P.8'> Product8 :> PMRequirement {
				doc /* Documentation of Basis of Estimate (cost and schedule) [Baseline at PDR]
				 * [Required per NPR 7120.5]
				 */
				:>> id = "Table I-2 P.8";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-2.P.9'> Product9 :> PMRequirement {
				doc /* CADRe [Baseline at SRR] [Required per NPR 7120.5] */
				:>> id = "Table I-2 P.9";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-2.P.10'> Product10 :> PMRequirement {
				doc /* Shared Infrastructure, Staffing, and Scarce Material Requirements and Plans
				 */
				:>> id = "Table I-2 P.10";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-2.P.11'> Product11 :> PMRequirement {
				doc /* Documentation of performance against plan/baseline, including status/closure
				 * of formal actions from previous KDP [Required per NPR 7120.5]
				 */
				:>> id = "Table I-2 P.11";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-2.P.12'> Product12 :> PMRequirement {
				doc /* Industrial Base and Supply Chain Risk Management (SCRM) Strategy and Status
				 * [Baseline at SDR] [Required per NPR 8735.2]
				 */
				:>> id = "Table I-2 P.12";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}
		}

		package TableI3 {
			doc /* The required products of Table I-3, Tightly Coupled Program Plan Control Plans
			 * Maturity Matrix, as Table C-1 lists them.
			 */

			requirement def <'I-3.C.1'> ControlPlan1 :> PMRequirement {
				doc /* Technical, Schedule, and Cost Control Plan [Baseline at SDR] [Required per
				 * NPR 7120.5]
				 */
				:>> id = "Table I-3 C.1";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.2'> ControlPlan2 :> PMRequirement {
				doc /* Safety and Mission Assurance Plan [Baseline at SDR] [Required per NPRs 8705.2
				 * and 8705.4]
				 */
				:>> id = "Table I-3 C.2";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.3'> ControlPlan3 :> PMRequirement {
				doc /* Risk Management Plan [Baseline at SDR] [Required NPR 8000.4] */
				:>> id = "Table I-3 C.3";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.4'> ControlPlan4 :> PMRequirement {
				doc /* Acquisition Strategy [Baseline at SDR] [Required per NPD 1000.5] */
				:>> id = "Table I-3 C.4";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.6'> ControlPlan6 :> PMRequirement {
				doc /* Systems Engineering Management Plan [Baseline at SDR] [Required per NPR
				 * 7123.1]
				 */
				:>> id = "Table I-3 C.6";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.7'> ControlPlan7 :> PMRequirement {
				doc /* Verification and Validation Plan [Baseline at PDR] [Required per NPR 7120.5,
				 * additional information in NPR 7123.1]
				 */
				:>> id = "Table I-3 C.7";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.8'> ControlPlan8 :> PMRequirement {
				doc /* System Security Plan [Baseline at CDR] [Required per NPR 2810.1] */
				:>> id = "Table I-3 C.8";
				:>> requirementOwner = "OCIO";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.9'> ControlPlan9 :> PMRequirement {
				doc /* Review Plan [Baseline at SRR] [Required per NPR 7120.5] */
				:>> id = "Table I-3 C.9";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.10'> ControlPlan10 :> PMRequirement {
				doc /* Mission Operations Plan [Baseline at ORR] [Required per NPR 7120.5] */
				:>> id = "Table I-3 C.10";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.11'> ControlPlan11 :> PMRequirement {
				doc /* NEPA Compliance Plan [Baseline at PDR] [Required per NPR 8580.1] */
				:>> id = "Table I-3 C.11";
				:>> requirementOwner = "OSI-EMD";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.12'> ControlPlan12 :> PMRequirement {
				doc /* Integrated Logistics Support Plan [Baseline at PDR] [Required per NPD 7500.1]
				 */
				:>> id = "Table I-3 C.12";
				:>> requirementOwner = "OSI-LMD";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.14'> ControlPlan14 :> PMRequirement {
				doc /* Configuration Management Plan [Baseline at SDR] [Required per NPR 7120.5;
				 * additional information in NPR 7123.1 and SAE/EIA 649]
				 */
				:>> id = "Table I-3 C.14";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.15'> ControlPlan15 :> PMRequirement {
				doc /* Security Plan [Baseline at PDR] [Required per NPR 1040.1 and NPR 1600.1] */
				:>> id = "Table I-3 C.15";
				:>> requirementOwner = "OPS";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.16'> ControlPlan16 :> PMRequirement {
				doc /* Technology Transfer (formerly Export) Control Plan [Baseline at PDR]
				 * [Required per NPR 2190.1]
				 */
				:>> id = "Table I-3 C.16";
				:>> requirementOwner = "OIIR";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.19'> ControlPlan19 :> PMRequirement {
				doc /* Human-Rating Certification Package [Initial at SRR; certified at MRR/FRR]
				 * [Required per NPR 8705.2]
				 */
				:>> id = "Table I-3 C.19";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.20'> ControlPlan20 :> PMRequirement {
				doc /* Quality Assurance Surveillance Plan [Baseline at SDR] [Required per NPR
				 * 8735.2 and NASA FAR Supplement part 1837.604]
				 */
				:>> id = "Table I-3 C.20";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.21'> ControlPlan21 :> PMRequirement {
				doc /* Orbital Collision Avoidance Plan [Baseline at PDR] [Required per NPR 8079.1]
				 */
				:>> id = "Table I-3 C.21";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-3.C.22'> ControlPlan22 :> PMRequirement {
				doc /* Human Systems Integration Approach [Baseline at SRR] [additional information
				 * in NASA/SP-20210010952 NASA HSI Handbook and NPR 7123.1]
				 */
				:>> id = "Table I-3 C.22";
				:>> requirementOwner = "OCE-OSMA-OCHMO";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}
		}

		package TableI4 {
			doc /* The required products of Table I-4, Project Milestone Products Maturity Matrix,
			 * as Table C-1 lists them.
			 */

			requirement def <'I-4.H.1'> HeadquartersAndProgram1 :> PMRequirement {
				doc /* PFAL [Final prior to Pre-Phase A] [Required per NPR 7120.5] */
				:>> id = "Table I-4 H.1";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.H.2'> HeadquartersAndProgram2 :> PMRequirement {
				doc /* FAD [Baseline at MCR] [Required per NPR 7120.5] */
				:>> id = "Table I-4 H.2";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.H.3'> HeadquartersAndProgram3 :> PMRequirement {
				doc /* Program Plan [Baseline at MCR] [Required per NPR 7120.5] */
				:>> id = "Table I-4 H.3";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.H.3.a'> HeadquartersAndProgram3a :> PMRequirement {
				doc /* Applicable Agency strategic goals [Baseline at MCR] [Required per NPR 7123.1]
				 */
				:>> id = "Table I-4 H.3.a";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.H.3.b'> HeadquartersAndProgram3b :> PMRequirement {
				doc /* Documentation of program-level requirements and constraints on the project
				 * (from the Program Plan) and stakeholder expectations, including mission
				 * objectives/goals and mission success criteria [Baseline at SRR] [Required per
				 * NPR 7123.1]
				 */
				:>> id = "Table I-4 H.3.b";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.H.3.c'> HeadquartersAndProgram3c :> PMRequirement {
				doc /* Documentation of driving mission, technical, and programmatic ground rules
				 * and assumptions [Baseline at SDR/MDR] [Required per NPR 7120.5]
				 */
				:>> id = "Table I-4 H.3.c";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.H.4'> HeadquartersAndProgram4 :> PMRequirement {
				doc /* Partnerships and interagency and international agreements [Baseline U.S.
				 * partnerships and agreements at SDR/MDR; Baseline International agreements at
				 * PDR]
				 */
				:>> id = "Table I-4 H.4";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.H.5'> HeadquartersAndProgram5 :> PMRequirement {
				doc /* ASM Decision Memorandum [additional information in NPD 1000.5] */
				:>> id = "Table I-4 H.5";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.H.6'> HeadquartersAndProgram6 :> PMRequirement {
				doc /* Mishap Preparedness and Contingency Plan [Baseline at SMSR] [Required per NPR
				 * 8621.1]
				 */
				:>> id = "Table I-4 H.6";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.1'> Technical1 :> PMRequirement {
				doc /* Concept Documentation [Approve at MCR] [Required per NPR 7123.1] */
				:>> id = "Table I-4 T.1";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.2'> Technical2 :> PMRequirement {
				doc /* Mission, Spacecraft, Ground, and Payload Architectures [Baseline mission and
				 * spacecraft architecture at SRR; Baseline ground and payload architectures at
				 * SDR/MDR] [Required per NPR 7123.1]
				 */
				:>> id = "Table I-4 T.2";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.3'> Technical3 :> PMRequirement {
				doc /* Project-Level, System, and Subsystem Requirements [Baseline project-level and
				 * system-level requirements at SRR; Baseline subsystem requirements at PDR]
				 * [Required per NPR 7123.1]
				 */
				:>> id = "Table I-4 T.3";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.4'> Technical4 :> PMRequirement {
				doc /* Design Documentation [Baseline at CDR] [Required per NPR 7123.1] */
				:>> id = "Table I-4 T.4";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.5'> Technical5 :> PMRequirement {
				doc /* Operations Concept Documentation [Baseline at PDR] [Required per NPR 7120.5]
				 */
				:>> id = "Table I-4 T.5";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.6'> Technical6 :> PMRequirement {
				doc /* Technology Readiness Assessment Documentation [Required per NPR 7120.5
				 * Appendix F FA Template]
				 */
				:>> id = "Table I-4 T.6";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.7'> Technical7 :> PMRequirement {
				doc /* Engineering Development Assessment Documentation [Required per NPR 7120.5
				 * Appendix F FA Template]
				 */
				:>> id = "Table I-4 T.7";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.8'> Technical8 :> PMRequirement {
				doc /* Heritage Assessment Documentation [Required per NPR 7120.5 Appendix F FA
				 * Template]
				 */
				:>> id = "Table I-4 T.8";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.9'> Technical9 :> PMRequirement {
				doc /* Systems Safety Analyses (e.g., safety data packages) [Baseline at CDR]
				 * [Required per NPR 8715.3]
				 */
				:>> id = "Table I-4 T.9";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.10'> Technical10 :> PMRequirement {
				doc /* Payload Safety Process Deliverables [Baseline at SIR] [Required per NPR
				 * 8715.7]
				 */
				:>> id = "Table I-4 T.10";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.11'> Technical11 :> PMRequirement {
				doc /* Verification and Validation Report [Baseline at MRR/FRR] [Required per NPR
				 * 7123.1]
				 */
				:>> id = "Table I-4 T.11";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.12'> Technical12 :> PMRequirement {
				doc /* Operations Handbook [Baseline at ORR] [additional information in NPR 7120.5
				 * Appendix A]
				 */
				:>> id = "Table I-4 T.12";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.13'> Technical13 :> PMRequirement {
				doc /* Orbital Debris Assessment Report [Final at SMSR] [Required per NPR 8715.6;
				 * additional information in NASA-STD-8719.14]
				 */
				:>> id = "Table I-4 T.13";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.14'> Technical14 :> PMRequirement {
				doc /* End of Mission Plans [Baseline at SMSR] [Required per NPR 8715.6; additional
				 * information in NASA-STD-8719.14, App B]
				 */
				:>> id = "Table I-4 T.14";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.16'> Technical16 :> PMRequirement {
				doc /* Decommissioning/Disposal Plan [Baseline at ORR] [Required per NPR 7123.1] */
				:>> id = "Table I-4 T.16";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.17'> Technical17 :> PMRequirement {
				doc /* Industrial Base and Supply Chain Risk Management (SCRM) Strategy and Status
				 * [Baseline at PDR] [Required per NPR 8735.2]
				 */
				:>> id = "Table I-4 T.17";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.T.18'> Technical18 :> PMRequirement {
				doc /* Criticality Identification Method for Hardware [Baseline at PDR] [Required
				 * per NPR 8735.2]
				 */
				:>> id = "Table I-4 T.18";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.M.1'> Management1 :> PMRequirement {
				doc /* Formulation Agreement [Baseline for Phase A at MCR; Baseline for Phase B at
				 * SDR/MDR] [Required per NPR 7120.5]
				 */
				:>> id = "Table I-4 M.1";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = true;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.M.2'> Management2 :> PMRequirement {
				doc /* Project Plan [Baseline at PDR] [Required per NPR 7120.5] */
				:>> id = "Table I-4 M.2";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = true;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.M.3'> Management3 :> PMRequirement {
				doc /* Documentation of performance against Formulation Agreement (see #1 above) or
				 * against plans for work to be accomplished during Implementation life-cycle
				 * phase, including performance against baselines and status/closure of formal
				 * actions from previous KDP [Required per NPR 7120.5]
				 */
				:>> id = "Table I-4 M.3";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.M.4.a'> Management4a :> PMRequirement {
				doc /* Top technical, cost, schedule and safety risks, risk mitigation plans, and
				 * associated resources [Required per NPR 7120.5]
				 */
				:>> id = "Table I-4 M.4.a";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.M.4.b'> Management4b :> PMRequirement {
				doc /* Staffing requirements and plans [Required per NPR 7120.5] */
				:>> id = "Table I-4 M.4.b";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.M.4.c.i'> Management4ci :> PMRequirement {
				doc /* Infrastructure requirements and plans [Required per NPR 9250.1, NPD 8800.14,
				 * and NPR 8820.2] Business case analysis for infrastructure [Required per NPR
				 * 8800.15.]
				 */
				:>> id = "Table I-4 M.4.c.i";
				:>> requirementOwner = "OSI-FRED";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.M.4.c.ii'> Management4cii :> PMRequirement {
				doc /* Capitalization Determination Form (CDF) (NASA Form 1739) [Required per NPR
				 * 9250.1]
				 */
				:>> id = "Table I-4 M.4.c.ii";
				:>> requirementOwner = "OCFO";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.M.4.d'> Management4d :> PMRequirement {
				doc /* Schedule [Baseline Integrated Master Schedule at PDR] [Required per NPR
				 * 7120.5]
				 */
				:>> id = "Table I-4 M.4.d";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.M.4.e'> Management4e :> PMRequirement {
				doc /* Cost Estimate [Baseline at PDR] [Required per NPR 7120.5] */
				:>> id = "Table I-4 M.4.e";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.M.4.f'> Management4f :> PMRequirement {
				doc /* Basis of Estimate (cost and schedule) [Required per NPR 7120.5] */
				:>> id = "Table I-4 M.4.f";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.M.4.g'> Management4g :> PMRequirement {
				doc /* Confidence Level(s) and supporting documentation [Baseline at PDR] [Required
				 * per NPR 7120.5]
				 */
				:>> id = "Table I-4 M.4.g";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.M.4.h'> Management4h :> PMRequirement {
				doc /* External Cost and Schedule Commitments [Baseline at PDR] [Required per NPR
				 * 7120.5]
				 */
				:>> id = "Table I-4 M.4.h";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.M.4.i'> Management4i :> PMRequirement {
				doc /* CADRe [Baseline at SRR] [Required per NPR 7120.5] */
				:>> id = "Table I-4 M.4.i";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-4.M.4.j'> Management4j :> PMRequirement {
				doc /* PMB [Baseline at PDR] [Required per NPR 7120.5 and NASA EVM Capability
				 * Process Documentation]
				 */
				:>> id = "Table I-4 M.4.j";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}
		}

		package TableI5 {
			doc /* The required products of Table I-5, Project Plan Control Plans Maturity Matrix,
			 * as Table C-1 lists them.
			 */

			requirement def <'I-5.C.1'> ControlPlan1 :> PMRequirement {
				doc /* Technical, Schedule, and Cost Control Plan [Baseline at SDR/MDR] [Required
				 * per NPR 7120.5]
				 */
				:>> id = "Table I-5 C.1";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.2'> ControlPlan2 :> PMRequirement {
				doc /* Safety and Mission Assurance Plan [Baseline at SRR] [Required per NPRs 8705.2
				 * and 8705.4]
				 */
				:>> id = "Table I-5 C.2";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.3'> ControlPlan3 :> PMRequirement {
				doc /* Risk Management Plan [Baseline at SRR] [Required per NPR 8000.4] */
				:>> id = "Table I-5 C.3";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.4'> ControlPlan4 :> PMRequirement {
				doc /* Acquisition Strategy [Baseline at SRR] [Required per NPD 1000.5] */
				:>> id = "Table I-5 C.4";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.6'> ControlPlan6 :> PMRequirement {
				doc /* Systems Engineering Management Plan [Baseline at SRR] [Required per NPR
				 * 7123.1]
				 */
				:>> id = "Table I-5 C.6";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.7'> ControlPlan7 :> PMRequirement {
				doc /* System Security Plan [Baseline at CDR] [Required per NPR 2810.1] */
				:>> id = "Table I-5 C.7";
				:>> requirementOwner = "OCIO";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.8'> ControlPlan8 :> PMRequirement {
				doc /* Software Management Plan(s) [Baseline at SDR/MDR] [Required per NPR 7150.2;
				 * additional information in NASA-STD-8739.8]
				 */
				:>> id = "Table I-5 C.8";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.9'> ControlPlan9 :> PMRequirement {
				doc /* Verification and Validation Plan [Baseline at PDR] [Required per NPR 7120.5,
				 * additional information in NPR 7123.1]
				 */
				:>> id = "Table I-5 C.9";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.10'> ControlPlan10 :> PMRequirement {
				doc /* Review Plan [Baseline at SRR] [Required per NPR 7120.5] */
				:>> id = "Table I-5 C.10";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.11'> ControlPlan11 :> PMRequirement {
				doc /* Mission Operations Plan [Baseline at ORR] [Required per NPR 7120.5] */
				:>> id = "Table I-5 C.11";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.12'> ControlPlan12 :> PMRequirement {
				doc /* NEPA Compliance Plan [Baseline at SDR/MDR] [Required per NPR 8580.1] */
				:>> id = "Table I-5 C.12";
				:>> requirementOwner = "OSI-EMD";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.13'> ControlPlan13 :> PMRequirement {
				doc /* Integrated Logistics Support Plan [Baseline at PDR] [Required per NPD 7500.1]
				 */
				:>> id = "Table I-5 C.13";
				:>> requirementOwner = "OSI-LMD";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.15'> ControlPlan15 :> PMRequirement {
				doc /* Integration Plan [Baseline at PDR] [Required per NPR 7120.5] */
				:>> id = "Table I-5 C.15";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.16'> ControlPlan16 :> PMRequirement {
				doc /* Configuration Management Plan [Baseline at SRR] [Required per NPR 7120.5;
				 * additional information in NPR 7123.1 and SAE/EIA 649]
				 */
				:>> id = "Table I-5 C.16";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.17'> ControlPlan17 :> PMRequirement {
				doc /* Security Plan [Baseline at PDR] [Required per NPR 1040.1 and NPR 1600.1] */
				:>> id = "Table I-5 C.17";
				:>> requirementOwner = "OPS";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.18'> ControlPlan18 :> PMRequirement {
				doc /* Project Protection Plan [Baseline at PDR] [Required per NPR 1058.1;
				 * additional information in NASA-STD-1006]
				 */
				:>> id = "Table I-5 C.18";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.19'> ControlPlan19 :> PMRequirement {
				doc /* Technology Transfer (formerly Export) Control Plan [Baseline at PDR]
				 * [Required per NPR 2190.1]
				 */
				:>> id = "Table I-5 C.19";
				:>> requirementOwner = "OIIR";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.21'> ControlPlan21 :> PMRequirement {
				doc /* Human-Rating Certification Package [Initial at SRR; certified at MRR/FRR]
				 * [Required per NPR 8705.2]
				 */
				:>> id = "Table I-5 C.21";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.22'> ControlPlan22 :> PMRequirement {
				doc /* Planetary Protection Plan [Baseline at PDR] [Required per NPD 8020.7 and NPR
				 * 8715.24]
				 */
				:>> id = "Table I-5 C.22";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.23'> ControlPlan23 :> PMRequirement {
				doc /* Nuclear Launch Authorization Plan [Baseline at SDR/MDR] [additional
				 * information in NPR 8715.26]
				 */
				:>> id = "Table I-5 C.23";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.24'> ControlPlan24 :> PMRequirement {
				doc /* Range Safety Risk Management Process Documentation [Baseline at SIR]
				 * [Required per NPR 8715.5]
				 */
				:>> id = "Table I-5 C.24";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.26'> ControlPlan26 :> PMRequirement {
				doc /* Quality Assurance Surveillance Plan [Baseline at SDR] [Required per NPR
				 * 8735.2 and NASA FAR Supplement part 1837.604]
				 */
				:>> id = "Table I-5 C.26";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.27'> ControlPlan27 :> PMRequirement {
				doc /* Orbital Collision Avoidance Plan [Baseline at PDR] [Required per NPR 8079.1]
				 */
				:>> id = "Table I-5 C.27";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-5.C.28'> ControlPlan28 :> PMRequirement {
				doc /* Human Systems Integration Approach [Baseline at SRR] [additional information
				 * in NASA/SP-20210010952 NASA HSI Handbook and NPR 7123.1]
				 */
				:>> id = "Table I-5 C.28";
				:>> requirementOwner = "OCE-OSMA-OCHMO";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}
		}

		package TableI6 {
			doc /* The required products of Table I-6, Single-Project Program Milestone Products
			 * Maturity Matrix, as Table C-1 lists them.
			 */

			requirement def <'I-6.P.1'> Product1 :> PMRequirement {
				doc /* PFAL [Final Prior to Pre-Phase A] [Required per NPR 7120.5] */
				:>> id = "Table I-6 P.1";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.P.2'> Product2 :> PMRequirement {
				doc /* FAD [Baseline at MCR] [Required per NPR 7120.5] */
				:>> id = "Table I-6 P.2";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.P.3'> Product3 :> PMRequirement {
				doc /* PCA [Baseline at PDR] [Required per NPR 7120.5] */
				:>> id = "Table I-6 P.3";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = false;
			}

			requirement def <'I-6.P.4'> Product4 :> PMRequirement {
				doc /* Traceability of Agency strategic goals and Mission Directorate requirements
				 * and constraints to program/project- level requirements and constraints
				 * [Baseline at SRR] [Required per NPR 7123.1]
				 */
				:>> id = "Table I-6 P.4";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.P.5'> Product5 :> PMRequirement {
				doc /* Documentation of driving mission, technical, and programmatic ground rules
				 * and assumptions [Baseline at SDR/MDR] [Required per NPR 7120.5]
				 */
				:>> id = "Table I-6 P.5";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.P.6'> Product6 :> PMRequirement {
				doc /* Partnerships and inter-agency and international agreements [Baseline U.S.
				 * partnerships and agreements at SDR/MDR; Baseline international agreements at
				 * PDR]
				 */
				:>> id = "Table I-6 P.6";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.P.7'> Product7 :> PMRequirement {
				doc /* ASM Decision Memorandum [additional information in NPD 1000.5] */
				:>> id = "Table I-6 P.7";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.P.8'> Product8 :> PMRequirement {
				doc /* Mishap Preparedness and Contingency Plan [Baseline at SMSR] [Required per NPR
				 * 8621.1]
				 */
				:>> id = "Table I-6 P.8";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.1'> Technical1 :> PMRequirement {
				doc /* Concept Documentation [Required per NPR 7123.1] */
				:>> id = "Table I-6 T.1";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.2'> Technical2 :> PMRequirement {
				doc /* Mission, Spacecraft, Ground, and Payload Architectures [Baseline mission and
				 * spacecraft architecture at SRR; baseline ground and payload architectures at
				 * SDR/MDR] [Required per NPR 7123.1]
				 */
				:>> id = "Table I-6 T.2";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.3'> Technical3 :> PMRequirement {
				doc /* Project-Level, System, and Subsystem Requirements [Baseline project-level and
				 * system-level requirements at SRR; baseline subsystem requirements at PDR]
				 * [Required per NPR 7123.1]
				 */
				:>> id = "Table I-6 T.3";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.4'> Technical4 :> PMRequirement {
				doc /* Design Documentation [Baseline at CDR] [Required per NPR 7123.1] */
				:>> id = "Table I-6 T.4";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.5'> Technical5 :> PMRequirement {
				doc /* Operations Concept Documentation [Baseline at PDR] [Required per NPR 7120.5]
				 */
				:>> id = "Table I-6 T.5";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.6'> Technical6 :> PMRequirement {
				doc /* Technology Readiness Assessment Documentation [Required per NPR 7120.5
				 * Appendix F FA Template]
				 */
				:>> id = "Table I-6 T.6";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.7'> Technical7 :> PMRequirement {
				doc /* Engineering Development Assessment Documentation [Required per NPR 7120.5
				 * Appendix F FA Template]
				 */
				:>> id = "Table I-6 T.7";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.8'> Technical8 :> PMRequirement {
				doc /* Heritage Assessment Documentation [Required per NPR 7120.5 Appendix F FA
				 * Template]
				 */
				:>> id = "Table I-6 T.8";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.9'> Technical9 :> PMRequirement {
				doc /* Systems Safety Analyses (e.g., safety data packages) [Baseline at CDR]
				 * [Required per NPR 8715.3]
				 */
				:>> id = "Table I-6 T.9";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.10'> Technical10 :> PMRequirement {
				doc /* Payload Safety Process Deliverables [Baseline at SIR] [Required per NPR
				 * 8715.7]
				 */
				:>> id = "Table I-6 T.10";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.11'> Technical11 :> PMRequirement {
				doc /* Verification and Validation Report [Baseline at MRR/FRR] [Required per NPR
				 * 7123.1]
				 */
				:>> id = "Table I-6 T.11";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.12'> Technical12 :> PMRequirement {
				doc /* Operations Handbook [Baseline at ORR] [additional information in NPR 7120.5
				 * Appendix A]
				 */
				:>> id = "Table I-6 T.12";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.13'> Technical13 :> PMRequirement {
				doc /* Orbital Debris Assessment Report [Final at SMSR] [Required per NPR 8715.6;
				 * additional information in NASA- STD-8719.14]
				 */
				:>> id = "Table I-6 T.13";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.14'> Technical14 :> PMRequirement {
				doc /* End of Mission Plans [Baseline at SMSR] [Required per NPR 8715.6; additional
				 * information in NASA-STD-8719.14, App B]
				 */
				:>> id = "Table I-6 T.14";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.16'> Technical16 :> PMRequirement {
				doc /* Decommissioning/Disposal Plan [Baseline at ORR] [Required per NPR 7123.1] */
				:>> id = "Table I-6 T.16";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.17'> Technical17 :> PMRequirement {
				doc /* Industrial Base and Supply Chain Risk Management (SCRM) Strategy and Status
				 * [Baseline at PDR] [Required per NPR 8735.2]
				 */
				:>> id = "Table I-6 T.17";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.T.18'> Technical18 :> PMRequirement {
				doc /* Criticality Identification Method for Hardware [Baseline at PDR] [Required
				 * per NPR 8735.2]
				 */
				:>> id = "Table I-6 T.18";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.M.1'> Management1 :> PMRequirement {
				doc /* Formulation Agreement [Baseline for Phase A at MCR; baseline for Phase B at
				 * SDR/MDR] [Required per NPR 7120.5]
				 */
				:>> id = "Table I-6 M.1";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = true;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.M.2'> Management2 :> PMRequirement {
				doc /* Program Plan [Baseline at PDR] [Required per NPR 7120.5] */
				:>> id = "Table I-6 M.2";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = true;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.M.3'> Management3 :> PMRequirement {
				doc /* Project Plan [Baseline at PDR] [Required per NPR 7120.5] */
				:>> id = "Table I-6 M.3";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = true;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.M.4'> Management4 :> PMRequirement {
				doc /* Documentation of performance against Formulation Agreement (see #1 above) or
				 * against plans for work to be accomplished during Implementation life-cycle
				 * phase, including performance against baselines and status/closure of formal
				 * actions from previous KDP [Required per NPR 7120.5]
				 */
				:>> id = "Table I-6 M.4";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.M.5.a'> Management5a :> PMRequirement {
				doc /* Top technical, cost, schedule and safety risks, risk mitigation plans, and
				 * associated resources [Required per NPR 7120.5]
				 */
				:>> id = "Table I-6 M.5.a";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.M.5.b'> Management5b :> PMRequirement {
				doc /* Staffing requirements and plans [Required per NPR 7120.5] */
				:>> id = "Table I-6 M.5.b";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.M.5.c.i'> Management5ci :> PMRequirement {
				doc /* Infrastructure requirements and plans [Required per NPR 9250.1, NPD 8800.14,
				 * and NPR 8820.2] Business case analysis for infrastructure [Required per NPR
				 * 8800.15.]
				 */
				:>> id = "Table I-6 M.5.c.i";
				:>> requirementOwner = "OSI-FRED";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.M.5.c.ii'> Management5cii :> PMRequirement {
				doc /* Capitalization Determination Form (CDF) (NASA Form 1739) [Required per NPR
				 * 9250.1]
				 */
				:>> id = "Table I-6 M.5.c.ii";
				:>> requirementOwner = "OCFO";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.M.5.d'> Management5d :> PMRequirement {
				doc /* Schedule [Baseline Integrated Master Schedule at PDR] [Required per NPR
				 * 7120.5]
				 */
				:>> id = "Table I-6 M.5.d";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.M.5.e'> Management5e :> PMRequirement {
				doc /* Cost Estimate (Risk-Informed or Schedule-Adjusted Depending on Phase)
				 * [Risk-informed and schedule-adjusted baseline at PDR] [Required per NPR
				 * 7120.5]
				 */
				:>> id = "Table I-6 M.5.e";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.M.5.f'> Management5f :> PMRequirement {
				doc /* Basis of Estimate (cost and schedule) [Required per NPR 7120.5] */
				:>> id = "Table I-6 M.5.f";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.M.5.g'> Management5g :> PMRequirement {
				doc /* Confidence Level(s) and supporting documentation [Baseline at PDR] [Required
				 * per NPR 7120.5]
				 */
				:>> id = "Table I-6 M.5.g";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.M.5.h'> Management5h :> PMRequirement {
				doc /* External Cost and Schedule Commitments [Baseline at PDR] [Required per NPR
				 * 7120.5]
				 */
				:>> id = "Table I-6 M.5.h";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = true;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.M.5.i'> Management5i :> PMRequirement {
				doc /* CADRe [Baseline at SRR] [Required per NPR 7120.5] */
				:>> id = "Table I-6 M.5.i";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-6.M.5.j'> Management5j :> PMRequirement {
				doc /* PMB [Baseline at PDR] [Required per NPR 7120.5 and NASA EVM Capability
				 * Process Documentation]
				 */
				:>> id = "Table I-6 M.5.j";
				:>> requirementOwner = "OCFO-SID";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}
		}

		package TableI7 {
			doc /* The required products of Table I-7, Single-Project Program Plan Control Plans
			 * Maturity Matrix, as Table C-1 lists them.
			 */

			requirement def <'I-7.C.1'> ControlPlan1 :> PMRequirement {
				doc /* Technical, Schedule, and Cost Control Plan [Baseline at SDR/MDR] [Required
				 * per NPR 7120.5]
				 */
				:>> id = "Table I-7 C.1";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.2'> ControlPlan2 :> PMRequirement {
				doc /* Safety and Mission Assurance Plan [Baseline at SRR] [Required per NPRs 8705.2
				 * and 8705.4]
				 */
				:>> id = "Table I-7 C.2";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.3'> ControlPlan3 :> PMRequirement {
				doc /* Risk Management Plan [Baseline at SRR] [Required per NPR 8000.4] */
				:>> id = "Table I-7 C.3";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.4'> ControlPlan4 :> PMRequirement {
				doc /* Acquisition Strategy [Baseline at SRR] [Required per NPD 1000.5] */
				:>> id = "Table I-7 C.4";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.6'> ControlPlan6 :> PMRequirement {
				doc /* Systems Engineering Management Plan [Baseline at SRR] [per NPR 7123.1] */
				:>> id = "Table I-7 C.6";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.7'> ControlPlan7 :> PMRequirement {
				doc /* System Security Plan [Baseline at CDR] [Required per NPR 2810.1] */
				:>> id = "Table I-7 C.7";
				:>> requirementOwner = "OCIO";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.8'> ControlPlan8 :> PMRequirement {
				doc /* Software Management Plan(s) [Baseline at SDR/MDR] [Required per NPR 7150.2;
				 * additional information in NASA- STD-8739.8]
				 */
				:>> id = "Table I-7 C.8";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.9'> ControlPlan9 :> PMRequirement {
				doc /* Verification and Validation Plan [Baseline at PDR] [Required per NPR 7120.5,
				 * additional information in NPR 7123.1
				 */
				:>> id = "Table I-7 C.9";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.10'> ControlPlan10 :> PMRequirement {
				doc /* Review Plan [Baseline at SRR] [Required per NPR 7120.5] */
				:>> id = "Table I-7 C.10";
				:>> requirementOwner = "NASA AA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.11'> ControlPlan11 :> PMRequirement {
				doc /* Mission Operations Plan [Baseline at ORR] [Required per NPR 7120.5] */
				:>> id = "Table I-7 C.11";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.12'> ControlPlan12 :> PMRequirement {
				doc /* NEPA Compliance Plan [Baseline at SDR/MDR] [Required per NPR 8580.1] */
				:>> id = "Table I-7 C.12";
				:>> requirementOwner = "OSI-EMD";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.13'> ControlPlan13 :> PMRequirement {
				doc /* Integrated Logistics Support Plan [Baseline at PDR] [Required per NPD 7500.1]
				 */
				:>> id = "Table I-7 C.13";
				:>> requirementOwner = "OSI-LMD";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.15'> ControlPlan15 :> PMRequirement {
				doc /* Integration Plan [Baseline at PDR] [Required per NPR 7120.5] */
				:>> id = "Table I-7 C.15";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.16'> ControlPlan16 :> PMRequirement {
				doc /* Configuration Management Plan [Baseline at SRR] [Required per NPR 7120.5;
				 * additional information in NPR 7123.1 and SAE/EIA 649]
				 */
				:>> id = "Table I-7 C.16";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.17'> ControlPlan17 :> PMRequirement {
				doc /* Security Plan [Baseline at PDR] [Required per NPR 1040.1 and NPR 1600.1] */
				:>> id = "Table I-7 C.17";
				:>> requirementOwner = "OPS";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.18'> ControlPlan18 :> PMRequirement {
				doc /* Project Protection Plan [Baseline at PDR] [Required per NPR 1058.1;
				 * additional information in NASA-STD-1006]
				 */
				:>> id = "Table I-7 C.18";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.19'> ControlPlan19 :> PMRequirement {
				doc /* Technology Transfer (formerly Export) Control Plan [Baseline at PDR]
				 * [Required per NPR 2190.1]
				 */
				:>> id = "Table I-7 C.19";
				:>> requirementOwner = "OIIR";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.21'> ControlPlan21 :> PMRequirement {
				doc /* Human-Rating Certification Package [Initial at SRR; certified at MRR/FRR]
				 * [Required per NPR 8705.2]
				 */
				:>> id = "Table I-7 C.21";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.22'> ControlPlan22 :> PMRequirement {
				doc /* Planetary Protection Plan [Baseline at PDR] [Required per NPD 8020.7 and NPR
				 * 8715.24]
				 */
				:>> id = "Table I-7 C.22";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.23'> ControlPlan23 :> PMRequirement {
				doc /* Nuclear Launch Authorization Plan [Baseline at SDR/MDR] [additional
				 * information in NPR 8715.26]
				 */
				:>> id = "Table I-7 C.23";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.24'> ControlPlan24 :> PMRequirement {
				doc /* Range Safety Risk Management Process Documentation [Baseline at SIR]
				 * [Required per NPR 8715.5]
				 */
				:>> id = "Table I-7 C.24";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.26'> ControlPlan26 :> PMRequirement {
				doc /* Quality Assurance Surveillance Plan [Baseline at SDR] [Required per NPR
				 * 8735.2 and NASA FAR Supplement part 1837.604]
				 */
				:>> id = "Table I-7 C.26";
				:>> requirementOwner = "OSMA";
				:>> tailoringDelegated = true;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.27'> ControlPlan27 :> PMRequirement {
				doc /* Orbital Collision Avoidance Plan [Baseline at PDR] [Required per NPR 8079.1]
				 */
				:>> id = "Table I-7 C.27";
				:>> requirementOwner = "OCE";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}

			requirement def <'I-7.C.28'> ControlPlan28 :> PMRequirement {
				doc /* Human Systems Integration Approach [Baseline at SRR] [additional information
				 * in NASA/SP-20210010952 NASA HSI Handbook and NPR 7123.1]
				 */
				:>> id = "Table I-7 C.28";
				:>> requirementOwner = "OCE-OSMA-OCHMO";
				:>> tailoringDelegated = false;
				:>> appliesToMDAA = false;
				:>> appliesToCenterDirector = false;
				:>> appliesToProgramOrProjectManager = true;
			}
		}
	}

	metadata def <pmComplies> PMCompliance {
		doc /* One entry of the Compliance Matrix: 'The "Comply?" column is filled in by the
		 * program or project to identify the program's or project's approach to the requirement.
		 * The project inserts an "FC" for "fully compliant," "T" for "tailored," or "NA" for a
		 * requirement that is "non-applicable"' (section C.1.3.4). `justification` 'documents
		 * the rationale for tailoring, documents how the requirement will be tailored, or
		 * justifies why the requirement is not applicable' (section C.1.3.5); `approval` is the
		 * name and title of the responsible authority, 'required only for tailored
		 * requirements' (section C.1.3.6). `requirement r : PMRequirements::Req2_2_10 {
		 * @PMCompliance { comply = ComplyKind::fullyCompliant; } }`
		 */
		:> annotatedElement : SysML::RequirementUsage;
		:> annotatedElement : SysML::RequirementDefinition;
		attribute comply : ComplyKind;
		attribute justification : String[0..1];
		attribute approval : String[0..1];
	}

	calc def PMComplianceEntries :> Query {
		doc /* The requirement usages below root that carry a PMCompliance annotation. */
		in root : Element;
		in depth : Integer default 16;
		WhereMetadata(
			source = Descendants(source = root, maxDepth = depth),
			'metadata' = "NPR7120::PMCompliance"
		)
	}

	calc def PMComplianceRegister :> Query {
		doc /* Table C-1 generated from the model: one row per compliance entry below root, in the
		 * columns of the table.
		 */
		in root : Element;
		in depth : Integer default 16;
		Project(
			source = PMComplianceEntries(root = root, depth = depth),
			columns = (
				Column(name = "Para #", path = "id"),
				Column(name = "NPR 7120.5 Requirement Statement", path = "type.documentation"),
				Column(name = "Requirement Owner", path = "requirementOwner"),
				Column(name = "Delegated", path = "tailoringDelegated"),
				Column(name = "MDAA", path = "appliesToMDAA"),
				Column(name = "CD", path = "appliesToCenterDirector"),
				Column(name = "PM", path = "appliesToProgramOrProjectManager"),
				Column(name = "Comply?", path = "NPR7120::PMCompliance::comply"),
				Column(name = "Justification", path = "NPR7120::PMCompliance::justification"),
				Column(name = "Approval", path = "NPR7120::PMCompliance::approval")
			)
		)
	}

	abstract part def PMComplianceMatrix :> Document {
		doc /* The Compliance Matrix of Appendix C: 'Program and project managers shall complete
		 * and maintain a Compliance Matrix (see Appendix C) for this NPR and attach it to the
		 * Formulation Agreement for projects in Formulation and/or the Program or Project Plan.'
		 * (section 2.2.10). Specialize it and add a table whose rows run PMComplianceRegister
		 * over the model's root. Section C.1.3.3 excuses a program or project from addressing
		 * the requirements whose PM column is empty.
		 */
		:>> title default = "NPR 7120.5 Compliance Matrix";
	}

	view def PMComplianceMatrixView :> GridView {
		doc /* Table of the compliance entries, one row per annotated requirement usage. */
		filter @PMCompliance;
		render asElementTable;
	}

	/* Semantic metadata: one keyword per definition with a base usage */

	metadata def <spaceFlightProgram> SpaceFlightProgramMetadata :> SemanticMetadata {
		doc /* The `#spaceFlightProgram` keyword: classifies a part definition or part usage as a
		 * SpaceFlightProgram by applying the definition and the `spaceFlightPrograms` base
		 * usage at once.
		 */
		:> annotatedElement : SysML::PartDefinition;
		:> annotatedElement : SysML::PartUsage;
		:>> baseType = spaceFlightPrograms meta SysML::Usage;
	}

	metadata def <spaceFlightProject> SpaceFlightProjectMetadata :> SemanticMetadata {
		doc /* The `#spaceFlightProject` keyword: classifies a part definition or part usage as a
		 * SpaceFlightProject by applying the definition and the `spaceFlightProjects` base
		 * usage at once.
		 */
		:> annotatedElement : SysML::PartDefinition;
		:> annotatedElement : SysML::PartUsage;
		:>> baseType = spaceFlightProjects meta SysML::Usage;
	}

	metadata def <decisionAuthority> DecisionAuthorityMetadata :> SemanticMetadata {
		doc /* The `#decisionAuthority` keyword: classifies a part definition or part usage as a
		 * DecisionAuthority by applying the definition and the `decisionAuthorities` base usage
		 * at once.
		 */
		:> annotatedElement : SysML::PartDefinition;
		:> annotatedElement : SysML::PartUsage;
		:>> baseType = decisionAuthorities meta SysML::Usage;
	}

	metadata def <managementCouncil> ManagementCouncilMetadata :> SemanticMetadata {
		doc /* The `#managementCouncil` keyword: classifies a part definition or part usage as a
		 * ManagementCouncil by applying the definition and the `managementCouncils` base usage
		 * at once.
		 */
		:> annotatedElement : SysML::PartDefinition;
		:> annotatedElement : SysML::PartUsage;
		:>> baseType = managementCouncils meta SysML::Usage;
	}

	metadata def <standingReviewBoard> StandingReviewBoardMetadata :> SemanticMetadata {
		doc /* The `#standingReviewBoard` keyword: classifies a part definition or part usage as a
		 * StandingReviewBoard by applying the definition and the `standingReviewBoards` base
		 * usage at once.
		 */
		:> annotatedElement : SysML::PartDefinition;
		:> annotatedElement : SysML::PartUsage;
		:>> baseType = standingReviewBoards meta SysML::Usage;
	}

	metadata def <authorityDocument> AuthorityDocumentMetadata :> SemanticMetadata {
		doc /* The `#authorityDocument` keyword: classifies a part definition or part usage as a
		 * AuthorityDocument by applying the definition and the `authorityDocuments` base usage
		 * at once.
		 */
		:> annotatedElement : SysML::PartDefinition;
		:> annotatedElement : SysML::PartUsage;
		:>> baseType = authorityDocuments meta SysML::Usage;
	}

	metadata def <spaceFlightKeyDecisionPoint> SpaceFlightKeyDecisionPointMetadata :> SemanticMetadata {
		doc /* The `#spaceFlightKeyDecisionPoint` keyword: classifies an occurrence definition or
		 * occurrence usage as a SpaceFlightKeyDecisionPoint by applying the definition and the
		 * `spaceFlightKeyDecisionPoints` base usage at once.
		 */
		:> annotatedElement : SysML::OccurrenceDefinition;
		:> annotatedElement : SysML::OccurrenceUsage;
		:>> baseType = spaceFlightKeyDecisionPoints meta SysML::Usage;
	}

	metadata def <spaceFlightLifeCycleReview> SpaceFlightLifeCycleReviewMetadata :> SemanticMetadata {
		doc /* The `#spaceFlightLifeCycleReview` keyword: classifies an action definition or action
		 * usage as a SpaceFlightLifeCycleReview by applying the definition and the
		 * `spaceFlightLifeCycleReviews` base usage at once.
		 */
		:> annotatedElement : SysML::ActionDefinition;
		:> annotatedElement : SysML::ActionUsage;
		:>> baseType = spaceFlightLifeCycleReviews meta SysML::Usage;
	}

	metadata def <otherReview> OtherReviewMetadata :> SemanticMetadata {
		doc /* The `#otherReview` keyword: classifies an action definition or action usage as a
		 * OtherReview by applying the definition and the `otherReviews` base usage at once.
		 */
		:> annotatedElement : SysML::ActionDefinition;
		:> annotatedElement : SysML::ActionUsage;
		:>> baseType = otherReviews meta SysML::Usage;
	}

	metadata def <pmRequirement> PMRequirementMetadata :> SemanticMetadata {
		doc /* The `#pmRequirement` keyword: classifies a requirement definition or requirement
		 * usage as a PMRequirement by applying the definition and the `pmRequirements` base
		 * usage at once.
		 */
		:> annotatedElement : SysML::RequirementDefinition;
		:> annotatedElement : SysML::RequirementUsage;
		:>> baseType = pmRequirements meta SysML::Usage;
	}
}
