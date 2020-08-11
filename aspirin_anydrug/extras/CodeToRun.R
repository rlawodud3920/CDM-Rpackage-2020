library(anydrugaspirin0615)
install.packages('devEMF')

options(fftempdir ="F:\\CDM\\temp")
#빌드 제대로 안될 때, 아래 4줄 실행하시면 돼요!
Sys.setenv(JAVA_HOME='C:/Program Files/Java/jdk1.8.0_221')
library(rJava)
library(DatabaseConnector)
options(java.parameters = "-Xmx16g")


# Maximum number of cores to be used:
maxCores <- parallel::detectCores()

# The folder where the study intermediate and result files will be written:

outputFolder <-  "F:\\CDM\\output\\aspirin\\anydrugaspirin0710"
# Details for connecting to the server:
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = "sql server",
                                                                server = "190.1.5.50",
                                                                user = 'sa',
                                                                password = '@kdcom2162',
                                                                port = '1433')

# The name of the database schema where the CDM data can be found:
cdmDatabaseSchema <- "NHIS_CDM_Sample.dbo"

# The name of the database schema and table where the study-specific cohorts will be instantiated:
cohortDatabaseSchema <- "datathon_test.dbo"
cohortTable <- "anydrugaspirin0710"

# Some meta-information that will be used by the export function:
databaseId <- "NHIS"
databaseName <- "Medicare Claims Synthetic Public Use Files (SynPUFs)"
databaseDescription <- "Medicare Claims Synthetic Public Use Files (SynPUFs) were created to allow interested parties to gain familiarity using Medicare claims data while protecting beneficiary privacy. These files are intended to promote development of software and applications that utilize files in this format, train researchers on the use and complexities of Centers for Medicare and Medicaid Services (CMS) claims, and support safe data mining innovations. The SynPUFs were created by combining randomized information from multiple unique beneficiaries and changing variable values. This randomization and combining of beneficiary information ensures privacy of health information."

# For Oracle: define a schema that can be used to emulate temp tables:
oracleTempSchema <- NULL

execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        oracleTempSchema = oracleTempSchema,
        outputFolder = outputFolder,
        databaseId = databaseId,
        databaseName = databaseName,
        databaseDescription = databaseDescription,
        createCohorts = T,
        synthesizePositiveControls = T,
        runAnalyses = T,
        runDiagnostics = T,
        packageResults = TRUE,
        maxCores = maxCores)

resultsZipFile <- file.path(outputFolder, "export", paste0("Results", databaseId, ".zip"))
dataFolder <- file.path(outputFolder, "shinyData")

prepareForEvidenceExplorer(resultsZipFile = resultsZipFile, dataFolder = dataFolder)

launchEvidenceExplorer(dataFolder = dataFolder, blind =FALSE, launch.browser = FALSE)
