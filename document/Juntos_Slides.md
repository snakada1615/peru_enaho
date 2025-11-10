# Juntos Program Slides

------------------------------------------------------------------------

## SLIDE 1: Juntos Program Overview

### Peru's Largest Conditional Cash Transfer (CCT) Program

**Program Name:** Juntos (National Programme of Direct Support to the Poorest)\
**Launch Year:** 2005\
**Coverage:** 638 districts across Peru (as of 2008); expanding continuously

------------------------------------------------------------------------

### Target Population

-   **Primary Beneficiaries:** Poorest households with:
    -   Children aged 0-19 years
    -   Pregnant women
    -   Women of childbearing age
-   **Household Focus:** \~98% female beneficiaries (mainly female household heads)

------------------------------------------------------------------------

### Transfer Amount & Frequency

-   **Monthly Transfer:** Approximately USD 30-35 (or \~100-200 Peruvian soles)
-   **Transfer Frequency:** Bimonthly (approximately USD 62-72 per two-month period)
-   **Distribution Method:**
    -   \~85% via bank transfer (Banco de la Nación)
    -   \~15% via cash distribution

------------------------------------------------------------------------

### Conditional Requirements (CCT Conditions)

**Health Conditions:** - Pregnant women: Regular prenatal check-ups - Children 0-5 years: Growth monitoring (CRED), vaccinations, nutritional assessments - All children: Participation in health programs (PACFO)

**Education Conditions:** - Children 6-19 years: School enrollment and ≥85% attendance rate

**General Requirements:** - Children must possess national ID (DNI)

------------------------------------------------------------------------

### Program Objectives

1.  **Poverty Reduction:** Increase household income and consumption
2.  **Health Improvement:** Increase utilization of preventive health services
3.  **Nutrition Enhancement:** Improve nutritional status of mothers and children
4.  **Education:** Increase school attendance and enrollment rates
5.  **Women's Empowerment:** Financial inclusion and decision-making participation

------------------------------------------------------------------------

### Evidence of Impact

-   Increased food consumption across nutritious food groups (vegetables, fruits, dairy)
-   Improved health service utilization by children \<5 and pregnant women
-   Enhanced nutritional intake, particularly for early-life exposure (ages 0-3)
-   Reduction in severe stunting (when exposed during critical early years)
-   No significant adverse effects (fertility, adult labor reduction, alcohol consumption)

------------------------------------------------------------------------

### Key Characteristic: Targeting Mechanism

**Three-Stage Selection Process:** 1. **District Selection:** Based on violence exposure, poverty rates, malnutrition levels 2. **Household Selection:** Proxy means test within eligible districts + presence of children \<14 or pregnant women 3. **Community Validation:** Final beneficiary list confirmed by community members and local authorities

------------------------------------------------------------------------

\pagebreak

## SLIDE 2: Juntos as an Instrumental Variable

### Why Use Juntos as an Instrument? The Endogeneity Problem

**Research Question:** Evaluate the causal relationship between **food consumption patterns** and **malnutrition incidence**

**Challenge:** Households' food consumption choices are **endogenous** to malnutrition status - Households experiencing malnutrition may have limited income to purchase diverse foods - Nutritional knowledge and health status affect food purchasing decisions - Reverse causality is plausible: poor nutrition → reduced income-earning capacity

**Solution:** Use Juntos program participation as an **Instrumental Variable (IV)**

------------------------------------------------------------------------

### Juntos Satisfies Key IV Requirements

#### 1. **Relevance (First-Stage Validity)**

-   Juntos program participation is **strongly correlated** with household income and cash availability
-   Increased cash transfers directly increase household purchasing power for food
-   Evidence: Juntos participation increases overall consumption by \~33% and income by \~43%
-   Impact on food consumption is documented: increases in spending on cereals, vegetables, fruits, oils, tubers, and sugar
-   **First-stage F-statistic implications:** Strong relationship between instrument and endogenous variable (food consumption patterns)

------------------------------------------------------------------------

#### 2. **Exogeneity (Exclusion Restriction)**

The program's **targeting mechanism ensures quasi-random variation** in who receives treatment:

**Geographic Randomness:** - Districts were selected based on poverty/violence indicators determined *before* Juntos rollout - Geographic/temporal variation in program rollout creates natural experiment conditions - Districts not yet treated serve as control group

**Household-Level Randomness:** - Within eligible districts, proxy means test determines eligibility objectively - Threshold-based selection creates discontinuity at eligibility cutoff - Community validation process minimizes strategic manipulation - Beneficiary selection is **independent of individual unobserved factors** affecting malnutrition (e.g., health preferences, dietary knowledge)

**Exogeneity Assumption:** Juntos participation affects malnutrition *only through* changes in food consumption, not through: - Direct access to health services (controlled separately) - Behavioral changes in feeding practices (not directly induced by cash) - Unobserved health knowledge (independent of program assignment)

------------------------------------------------------------------------

### Econometric Justification

**Two-Stage Least Squares (2SLS) Framework:**

*First Stage:*

```         
Food_Consumption_i = α₀ + α₁·Juntos_i + α₂·X_i + ε₁_i
```

Where Juntos_i predicts food consumption based on program participation

*Second Stage:*

```         
Malnutrition_i = β₀ + β₁·Food_Consumption_i + β₂·X_i + ε₂_i
```

Where predicted food consumption (instrumented) estimates causal effect on malnutrition

------------------------------------------------------------------------

### Validity Tests & Empirical Evidence

**Empirical Evidence Supporting IV Validity:**

1.  **Wu-Hausman Endogeneity Test:** Studies reject null hypothesis of non-endogeneity of Juntos variable
    -   Confirms food consumption endogeneity and validates IV approach
2.  **Strong First Stage:**
    -   Juntos participation demonstrates robust predictive power for food consumption patterns
    -   Documented increases across multiple food groups validate instrument strength
3.  **Policy Discontinuity:**
    -   Geographic rollout timing creates quasi-experimental variation
    -   Households in pre-Juntos districts form valid counterfactuals
4.  **Balance of Covariates:**
    -   Juntos-eligible but not-yet-treated districts comparable to treated districts on observables
    -   Supports exogeneity of instrument assignment

------------------------------------------------------------------------

### Why Juntos is Superior to Alternative Approaches

| Approach | Limitation |
|----|----|
| **OLS Regression** | Omitted variable bias from unmeasured nutritional knowledge, health preferences |
| **Matching/Propensity Score** | Requires complete measurement of selection criteria; community validation introduces unobservables |
| **Difference-in-Differences** | Requires strong parallel trends assumption; pre-program malnutrition trends may differ |
| **Juntos IV** | ✓ Exploits policy discontinuity; ✓ Addresses endogeneity; ✓ Supported by program design |

------------------------------------------------------------------------

### Practical Implications for Analysis

**Strengths of Juntos as IV:** - **Natural Experiment:** Government rollout creates exogenous variation - **Abundant Data:** Multiple datasets contain Juntos participation information (ENAHO, ENDES) - **Sharp Discontinuity:** Clear eligibility rules enable regression discontinuity designs - **Documented Impacts:** Prior research validates first-stage relationship

**Methodological Considerations:** - Use multiple first-stage robustness checks - Control for geographic/temporal confounders - Consider alternative instruments (e.g., program rollout dates, distance from district capitals) - Validate exclusion restriction through sensitivity analysis

------------------------------------------------------------------------

\pagebreak

## SLIDE 3: The Mechanism - How Juntos Influences the Food-Malnutrition Relationship

### Causal Pathway: Income → Food Consumption → Nutritional Status

**Direct Mechanism:** 1. Juntos cash transfer → Increased household income 2. Increased purchasing power → Dietary diversification (more nutritious food groups) 3. Improved diet quality → Better nutritional outcomes (reduced stunting, wasting, anemia)

**Evidence Supporting Pathway:** - Juntos households increase consumption of nutrient-rich foods by 10-15% monthly per capita - Increases span: vegetables (+2.52 soles), fruits (+1.40 soles), grains (+0.72 soles), dairy products - Consumption of "lower quality" foods (alcohol) decreases 15% among Juntos beneficiaries - Pattern consistent with income effect: households prioritize nutritious foods with discretionary income

------------------------------------------------------------------------

### Why IV Approach Captures True Effect

**Problem with Naive Comparison:** - Observing correlation between food consumption and malnutrition among Juntos households conflates: - **Treatment effect** (causality we want) - **Selection bias** (unobservables determining program participation)

**IV Solution:** - Uses *only* variation in food consumption driven by exogenous cash transfer - Removes correlation between food consumption and unobserved nutritional knowledge/preferences - Isolates pure income effect on dietary choices → malnutrition reduction

**Result:** Causal estimate of food consumption on malnutrition that is: - Unbiased (corrects endogeneity) - Consistent (valid under mild assumptions) - Efficient (leverages policy variation)

------------------------------------------------------------------------

### Heterogeneous Effects & Age Specificity

**Critical Finding:** Impact on malnutrition is **strongest for early-life exposure (ages 0-3)**

**Why Age Matters:** - Ages 0-3 are critical periods for physical and cognitive development - Early nutritional investment has highest return on investment - Stunting before age 3 becomes largely irreversible after age 5

**Implications for IV Analysis:** - Stratify analysis by age at Juntos exposure - Expect stronger second-stage effects for younger cohorts - Control for duration in program as additional predictor

------------------------------------------------------------------------

### Limitations of IV Approach & Sensitivity Concerns

1.  **Exclusion Restriction Violation Risk:**
    -   If Juntos affects malnutrition through mechanisms *other than* food consumption (e.g., health knowledge from program staff interactions), IV estimate captures broader effect
    -   Mitigation: Include health service utilization as control variable
2.  **Weak Instruments:**
    -   If Juntos participation weakly predicts food consumption in some subsamples, IV estimates become unstable
    -   Mitigation: Test first-stage F-statistics; use robust IV methods
3.  **Compliance Issues:**
    -   If households don't comply fully with conditions, reduced-form effects weaker
    -   Mitigation: Use intention-to-treat (ITT) framework; estimate Local Average Treatment Effect (LATE)
4.  **Measurement Error:**
    -   Self-reported food consumption and malnutrition indicators subject to error
    -   Mitigation: Use multiple imputation; conduct sensitivity analyses with alternative outcome measures

------------------------------------------------------------------------

### Conclusion

**Juntos as IV is justified because:** - ✓ Strong first stage: program participation predicts food consumption - ✓ Exogenous assignment: targeting mechanism independent of omitted variables - ✓ Supported by natural experiment design: geographic/temporal variation - ✓ Economic theory: income transfers → dietary diversification → nutrition improvement - ✓ Empirical precedent: prior studies validate IV approach for Juntos

**Expected Result:** IV estimation reveals causal effect of dietary diversification on malnutrition reduction, with effects concentrated among early-exposed children.
