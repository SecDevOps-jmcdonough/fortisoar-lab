# FortiSOAR Workshop

## Technologies Utilized

* FortiSOAR
* FortiAnalyzer
* FortiGate
* Azure
* FlightSim by Alpha SOC

Fortinet Security Orchestration Platform™ (FortiSOAR™) is a scalable, awareness-driven, and encrypted security management intelligence platform. FortiSOAR is a centralized hub for your security operations and dramatically improves the effectiveness and efficiency of your security operations teams, by providing automation and customizable mechanisms for prevention, detection, and response to cybersecurity threats.

This workshop uses FortiSOAR, FortiAnalyzer, and FortiGate deployed in Azure. You will will connect these components via APIs (Connectors) and spoof malicious data creating alerts in FortiSOAR. Once we have all that done, we will proceed to tackle the Security event in FortiSOAR like a real SOC team would. Today you will be putting on your ADMIN hat, Security Architect Hat, and Analyst Hat.

## Workshop Main Objectives

* FortiSOAR
  * Deployment
  * Connector Configuration
  * Asset Management
  * Data Ingestion
  * Playbook deploy and Run
  * Incident Response Workshop

* FortiAnalyzer
  * Create API User
  * Connect to FortiSOAR

* FortiGate
  * Connect to FortiAnalyzer

***

## Deploy / Setup the environment (40min)

### Task 1 FortiSOAR Configuration and Licensing

> All of the CLI steps in this task can be completed via the Azure Cloudshell environment.
> Multiple browser tabs can be opened to the Azure environment and Cloudshell.

#### Login to Azure / Display Environment Information

1. Login to [Azure](https://portal.azure.com) with provided credentials
1. Open Cloudshell
1. Change to the FortiSOAR workshop directory
    * `cd ./fortisoar-lab/fortisoar-fortianalyzer-fortigate/`
1. Run
    * `terraform output`  - to display lab IP addresses and credentials

  ![Azure Environment](images/az-login-01.jpg)
  ![Azure Environment](images/az-login-02.jpg)
  ![Azure Environment](images/az-login-04.jpg)

#### Un-configured FortiSOAR

<details>

> The FortiSOAR VM has been deployed into an Azure Resource Group and needs to be configured. Configuration happens via a script that is run automatically when the `csadmin` user does an SSH login to the FortiSOAR VM. When the configuration script completes a UUID is generated for the FortiSOAR VM, this UUID is required for licensing.

1. Run
    * `ssh csadmin@<ip-address-of-fortisoar-vm>` insert your FortiSOAR IP or run the command below to have the IP pulled from the terraform output

    ```bash
    ssh csadmin@$(terraform output | grep FortiSOAR | awk -F/ '{print $3}' | sed -e 's/\"$//')

    ```

    * Current Password is `changeme`
    * Supply Current Password `changeme` again
    * Supply New Password and confirm it

1. Restart ssh session `ssh csadmin@<ip-address-of-fortisoar-vm>` with new password
1. An automated FortiSOAR configuration script will run.

    1. Select "Continue"
    1. Select "Accept"
    1. Select "OK"
    1. Select "OK"
    1. Select "OK"
    1. Select "OK"
    1. Select "Proceed"

    * **IMPORTANT DO NOT CLICK OK BEFORE COPYING THE DEVICE UUID**

    1. Use the Device UUID to register your license at [support.fortinet.com](https://support.fortinet.com)
    1. Download license file

    1. Browse to FortiSOAR web interface
    1. Use your FortiCloud Account to activate the trial license.
        1. User FortiCloud Account to Activate Trial License
        1. Accept License Agreement
    1. Login
        * Username: `csadmin`
        * Password: `changeme`
    1. Change Password

  ![FortiSOAR Deploy](images/fsr-deploy-01.jpg)
  ![FortiSOAR Deploy](images/fsr-deploy-02.jpg)
  ![FortiSOAR Deploy](images/fsr-deploy-03.jpg)
  ![FortiSOAR Deploy](images/fsr-deploy-04.jpg)
  ![FortiSOAR Deploy](images/fsr-deploy-05.jpg)
  ![FortiSOAR Deploy](images/fsr-deploy-06.jpg)
  ![FortiSOAR Deploy](images/fsr-deploy-07.jpg)
  ![FortiSOAR Deploy](images/fsr-deploy-08.jpg)

  </details>

#### Pre-configured FortiSOAR

<details>

> The FortiSOAR VM has been deployed into an Azure Resource Group already configured. The UUID needs to be retrieved and your license updated.

#### Retrieve the UUID of the FortiSOAR instance

1. Run this Cloud shell command to retieve the UUID
    * `Get-AzVM -ResourceGroupName ${env:USER}_fortisoar_fortianalyzer_fortigate -Name vm-fsr | %{$_.VmId.Replace("-","")}`
1. Update the UUID in the license and download
1. Upload the License to FortiSOAR

  ![FortiSOAR Pre-Configured](images/fsr-pre-config-01.jpg)
  ![FortiSOAR Pre-Configured](images/fsr-pre-config-02.jpg)
  ![FortiSOAR Pre-Configured](images/fsr-pre-config-03.jpg)
  ![FortiSOAR Pre-Configured](images/fsr-pre-config-04.jpg)
  ![FortiSOAR Pre-Configured](images/fsr-pre-config-05.jpg)

</details>

### Task 2 Setup FortiAnalyzer / Create API User

#### Activate FortiAnalyzer License / Change Password

1. Open Browser to FortiAnalyzer web interface
    * Upload license file
1. Login to FortiAnalyzer web interface
    * Credentials are displayed using `terraform output`
    * Complete FortiAnalyzer setup, accept defaults
1. Change FortiAnalyzer Password

#### Create API User for Connection to FortiSOAR

FortiSOAR will ingest logs from FortiAnalyzer, the `apiuser` will be used by the **FortiAnalyzer Connector** in FortiSOAR

1. Click "System Settings"
1. Click "Admin"
1. Click "Administrators"
1. Click "+ Create New"
    * User Name: **apiuser**
    * Password: **SecurityFabric**
    * Admin Profile: **Super_User**
    * JSON API Access: **Read-Write**
    * Click "OK"

  ![FortiAnalyzer API User](images/faz-setup-01.jpg)
  ![FortiAnalyzer API User](images/faz-setup-02.jpg)
  ![FortiAnalyzer API User](images/faz-setup-03.jpg)

### Task 3 Connect FortiGate to FortiAnalyzer

Traffic logs from the FortiGate will be sent to FortiAnalyzer to then be ingested by FortiSOAR

1. Login to FortiGate web interface
    * Credentials are displayed using `terraform output`

1. Edit FortiAnalyzer Fabric Connector
1. Enable FortiAnalyzer Fabric Connector
1. Enter FortiAnalyzer - IP address can be found using `terraform output`
1. Click "Test Connectivity"
    * "Unauthorized" should appear beneath the IP address
1. Select "Upload option": "Real Time"
1. Turn off "Verify FortiAnalyzer certificate"
1. Click "OK"
1. Re-Edit FortiAnalyzer Fabric Connector
1. Click "Authorize" in the ***FortiAnalyzer Status*** right-hand pane
    * Login to FortiAnalyzer
    * Click "Approve"
    * Click "OK"
1. Click "Test Connectivity"
    * "Connected" should appear beneath the IP address

  ![FortiFortiGate Setup](images/fgt-setup-01.jpg)
  ![FortiFortiGate Setup](images/fgt-setup-02.jpg)
  ![FortiFortiGate Setup](images/fgt-setup-03.jpg)
  ![FortiFortiGate Setup](images/fgt-setup-04.jpg)

### Task 4 Setup Malicious Network Traffic Utility and Generate Traffic

**vm-harry-pc** is a user VM that is used to generate malicious / suspect traffic. SSH to the VM via a CLI session on the FortiGate and setup the utility to generate the traffic.

1. Open CLI Session on FortiGate
1. SSH to vm-harry-pc (10.135.6.5)
    * `execute ssh azureuser@10.135.6.5`
1. Download, Install and Run the Malicious Traffic Network Utility - FlightSim by Alpha SOC
    * Use the bash commands below

  ```bash
  wget https://github.com/alphasoc/flightsim/releases/download/v2.2.2/flightsim_2.2.2_linux_64-bit.deb
  sudo dpkg -i flightsim_2.2.2_linux_64-bit.deb
  flightsim run

  ```

1. View the FortiGate Log "Forward Traffic" and inspect some of the IPs. There will be several marked as "Known malicious site"

  ![FlightSim Setup](images/flightsim-setup-01.jpg)
  ![FlightSim Setup](images/flightsim-setup-02.jpg)
  ![FlightSim Setup](images/flightsim-setup-03.jpg)

## FortiSOAR Connectors and Playbooks (40min)

### Task 1 Configure FortiSOAR Connectors

The FortiSOAR Connectors provide interaction with other products and service. The connectors can be used in FortiSOAR Playbooks as well as triggered manually.

#### Configure FortiAnalyzer Connector

The FortiSOAR FortiAnalyzer connector enables FortiSOAR to ingest FortiAnalyzer logs.

1. Login to FortiSOAR web interface
1. Click on Automation -> Connectors
1. Click the "Discover" Tab
1. Enter "FortiAnalyzer" in the search bar
1. Click the "FortiAnalyzer" tile
1. Click "Install"
1. Click "Confirm" in the Confirm Dialog
1. Create a Configuration
    * Configuration Name: `Workshop config`
    * Server URL: `https://<your-faz-ip-address>`
    * Username: `apiuser`
    * Password: `SecurityFabric`
    * ADOM Name: `root`
    * Port: `443`
    * Uncheck Verify SSL
    * Click "Save" <- When a successful connection is made the connector will display a "HEALTH CHECK: AVAILABLE" indicator

  ![FortiSOAR FortiAnalyzer Connector Setup](images/fsr-faz-connector-01.jpg)
  ![FortiSOAR FortiAnalyzer Connector Setup](images/fsr-faz-connector-02.jpg)
  ![FortiSOAR FortiAnalyzer Connector Setup](images/fsr-faz-connector-03.jpg)
  ![FortiSOAR FortiAnalyzer Connector Setup](images/fsr-faz-connector-04.jpg)

#### Configure Azure Compute Connector

The Azure Compute Connector for FortiSOAR provides a number of actions to FortiSOAR for Managing Azure VMs. The Playbooks used during this workshop will stop a VM that is accessing malicious hosts, triage that host and then start it.

1. Click on Automation -> Connectors
1. Click the "Discover" Tab
1. Enter "Azure Compute" in the search bar
1. Click the "Azure Compute" tile
1. Click "Install"
1. Click "Confirm" in the Confirm Dialog
1. Create a Configuration
    * Configuration Name: `Workshop config`
    * Directory (Tenant) ID: *Value to be provided*
    * Application (Client) ID: *Value to be provided*
    * Application (Client) Secret: *Value to be provided*
    * Click "Save" <- When a successful connection is made the connector will display a "HEALTH CHECK: AVAILABLE" indicator

  ![FortiSOAR Azure Compute Connector Setup](images/fsr-azc-connector-01.jpg)

### Task 2 Create and Execute FortiSOAR Playbooks

#### Asset Records Playbook - Create

The Terraform code that created this environment generated an assets file, `vm_assets.json`,  of the user VMs in the environment. The contents will be run through a FortiSOAR playbook to create asset records in FortiSOAR. From an environment management perspective, an assets playbook could be run manualy every time an environment is updated or via an API call in a CI/CD pipeline. Playbooks can use the asset records to correlate Azure private IP addresses seen in FortiGate logs to the Azure name of the VM.

1. Click on Automation -> Playbooks
1. Click "+ Add Playbook"
    1. Name: `Asset Records`
    1. Click "Create"
    1. Choose a Trigger - "Manual"
    1. Select Execution Behavior - "Does not require a record input to run"
    1. Select Module - "Assets"
    1. Click "Save"
    1. Grab the Blue Orb next to the **Start** step and drag out a new step
    1. Select "Set Variable"
    1. Step Name: "Asset Records"
    1. Variables: "+ Add New"
        1. Variable: `assets`
        1. Value: copy and paste the JSON text below

            ```bash
            {
              "Results": [
                      {"ip":"10.135.6.4","name":"vm-bobby-pc"},
                      {"ip":"10.135.6.5","name":"vm-harry-pc"},
                      {"ip":"10.135.6.6","name":"vm-sally-pc"},
                  ]
            }
            ```

            These are the contents of the file `vm-assets.json` from the Cloudshell terraform directory. This file was created as part of the Terraform apply step.

        1. Click "Save"

    1. Grab the Blue Orb next to the **Asset Records** step and drag out a new step
    1. Select "Create Record"
    1. Step Name: "Create Assets"
    1. Select Model - "Assets"
    1. MAC Address: NONE
    1. Click "+ Loop" at bottom of screen
    1. Click in the "Array of objects..." field
        1. Enter `{{vars.assets.Results}}`  
    1. Scroll up to Fields
        1. "IP Address" field enter `{{vars.item.ip}}`
        1. "Hostname" field enter `{{vars.item.name}}`
    1. Click "Save"
    1. Click "Save Playbook"

  ![FortiSOAR Asset Record Playbook Create](images/fsr-asset-playbook-01.jpg)
  ![FortiSOAR Asset Record Playbook Create](images/fsr-asset-playbook-02.jpg)
  ![FortiSOAR Asset Record Playbook Create](images/fsr-asset-playbook-03.jpg)
  ![FortiSOAR Asset Record Playbook Create](images/fsr-asset-playbook-04.jpg)
  ![FortiSOAR Asset Record Playbook Create](images/fsr-asset-playbook-05.jpg)
  ![FortiSOAR Asset Record Playbook Create](images/fsr-asset-playbook-06.jpg)
  ![FortiSOAR Asset Record Playbook Create](images/fsr-asset-playbook-07.jpg)
  ![FortiSOAR Asset Record Playbook Create](images/fsr-asset-playbook-08.jpg)
  ![FortiSOAR Asset Record Playbook Create](images/fsr-asset-playbook-09.jpg)

#### Asset Records Playbook Run

1. Click on Resources -> Assets
1. Click "Execute"
1. Click "Asset Records" <- the screen will refresh with the asset records

  ![FortiSOAR Asset Record Playbook Execute](images/fsr-asset-playbook-execute-01.jpg)
  ![FortiSOAR Asset Record Playbook Execute](images/fsr-asset-playbook-execute-02.jpg)
  ![FortiSOAR Asset Record Playbook Execute](images/fsr-asset-playbook-execute-03.jpg)

#### Block C&C Playbook Create

Bobby, Harry, and Sally have VMs in Azure. Recently Harry's VM has been visiting hosts on the Internet that have bad reputations, some hosts are known Command and Control servers. This FortiSOAR Playbook will recognize the interactions from Harry's VM to these Command and Control Serves and shutdown Harry's VM. After the VM has been shutdown the incident will be managed through FortiSOAR. Maybe Harry's VM will be turned back on or maybe Harry has some explaining to do...

1. Click on Automation -> Playbooks
1. Click "+ Add Playbook"
    1. Name: `Block C&C`
    1. Click "Create"
    1. Choose a Trigger - "On Create"
    1. Select Resource - "Alerts"
    1. Click "+ ADD CONDITION"
        1. Select a field - `Name`
        1. Select Operator - `Contains`
        1. Name - `Traffic to C&C`
    1. Click "Save"
    1. Grab the Blue Orb next to the **Start** step and drag out a new step
    1. Select "Find Records"
    1. Step Name "Find Assets"
    1. Select Module - "Assets"
    1. Click "+ ADD CONDITION"
        1. Select a field - `IP Address`
        1. Select Operator - `Equals`
        1. IP Address Field
            1. Click in field
            1. Find and Click "Source IP" in the Dynamic Values open "Input" -> "Records" -> "modules" -> "Alerts" -> "Spource IPq". The result in the field should be, `{{vars.input.records[0].sourceIp}}`
    1. Click "Save"
    1. Grab the Blue Orb next to the **Find Asset** step and drag out a new step
    1. Select "Connector"
    1. Search for "Azure Compute"
    1. Click "Azure Compute"
    1. Step Name: "Stop Instance"
    1. Select Action - "Stop an Instance"
    1. Inputs
        1. Subscription ID - Pick the only available option
        1. Resource Group Name - Pick your Resource Group Name
        1. Virtual Machine Name - Click the curly braces {}
            1. Click in the empty field
            1. In Dynamic Values open "Step Results" -> "Find Assets[]"
            1. Select Hostname - the result in the field should be. `{{vars.steps.Find_Assets[0].hostname}}`
    1. Click "Save"
    1. Grab the Blue Orb next to the **Stop Instance** step and drag out a new step
    1. Click "Update Record"
    1. Step Name "Update Severity and Add Notes"
    1. Model "Alerts"
    1. Record IRI - Click in field and select Dynamic Values open "Input" -> "Records" -> "modules" -> "Alerts" -> "@id"
        * Value in field should be `{{vars.input.records[0]['@id']}}`
    1. Type asset in search box under Fields
    1. Add asset ID to "Correlations" -> "Assets" Field - Click in field and select Dynamic Values open  "Step Results" -> "Find Assets []" -> "@id"
        * Value in field should be `{{vars.steps.Find_Assets[0]['@id']}}`
    1. Click "+ Message" Button at bottom of screen
    1. Add Message
        1. `Hostname: {{vars.steps.Find_Asset[0].hostname}} was shutdown by playbook due to malicious activity.`
        1. Highlight the word malicious in red
    1. Click "Save"
    1. Click "Save Playbook"

    ![FortiSOAR Block C&C Playbook Create](images/fsr-block-cnc-01.jpg)
    ![FortiSOAR Block C&C Playbook Create](images/fsr-block-cnc-02.jpg)
    ![FortiSOAR Block C&C Playbook Create](images/fsr-block-cnc-03.jpg)
    ![FortiSOAR Block C&C Playbook Create](images/fsr-block-cnc-04.jpg)

#### Incident Response Playbook Import

The Incident Response Playbook is much larger than the Playbooks that were just created and will be imported. Playbooks can be exported and imported into FortiSOAR. For this task the Playbook needs to be copied from this repository to a file on your local system so that it can be imported in to FortiSOAR.

1. Copy the **raw** contents of the [incident response playbook](https://github.com/FortinetSecDevOps/fortisoar-lab/blob/main/fortisoar-fortianalyzer-fortigate/incident-response-fortisoar-workshop.json)
1. Save to a local file with with a `.json` extension.
1. Click on Automation -> Playbooks
1. Click "Import"
1. Drag file to import or Click and select file from directory
1. Click "Import"

    ![FortiSOAR Playbook Import](images/fsr-playbook-import-01.jpg)
    ![FortiSOAR Playbook Import](images/fsr-playbook-import-02.jpg)
    ![FortiSOAR Playbook Import](images/fsr-playbook-import-03.jpg)
    ![FortiSOAR Playbook Import](images/fsr-playbook-import-04.jpg)
    ![FortiSOAR Playbook Import](images/fsr-playbook-import-05.jpg)
    ![FortiSOAR Playbook Import](images/fsr-playbook-import-06.jpg)

### Task 3 Ingest FortiAnalyzer Data

#### Setup Data Ingestion

Setup FortiAnalyzer Data ingestion to retrieve FortiGate traffic logs. Map the `epip` field in the ingested record to the Source IP field in the FortiSOAR records.

> Prior to running this data ingestion step, use the FortiGate CLI to ssh to `vm-harry-pc` and run the FlightSim traffic generator again. `flightsim run`

1. Click on Automation -> Data Ingestion
1. Select "FortiAnalyzer"
1. Click "Configure Ingestion"
1. Click "Let's start by fetching some data"
1. Clear the Search Query Field
1. Set Maximum Records to Fetch to `200`
1. Set Pull Sample Events in Past X Minutes to `120`
1. Click "FETCH DATA"
1. Search for "Source IP" in Field Mapping
1. Click in "Source IP" Field
1. Find an Click `epip` in the Sample Data
1. Click "Save Mapping & Continue"
1. Click "Save Settings & Continue" on the Schedule Data Ingestion page
1. Click "Trigger Ingestion Now"
1. Click "Yes, Trigger Ingestion Now"
1. Click "Done"

    ![FortiSOAR Data Ingestion](images/fsr-data-ingest-01.jpg)
    ![FortiSOAR Data Ingestion](images/fsr-data-ingest-02.jpg)
    ![FortiSOAR Data Ingestion](images/fsr-data-ingest-03.jpg)
    ![FortiSOAR Data Ingestion](images/fsr-data-ingest-04.jpg)
    ![FortiSOAR Data Ingestion](images/fsr-data-ingest-05.jpg)
    ![FortiSOAR Data Ingestion](images/fsr-data-ingest-06.jpg)

## FortiSOAR Incident Response (10min)

### Task 1 View Alert and Escalate

A correctly configured "Block C&C" playbook will generate several alerts and will have shut down **vm-harry-pc**.

1. Click on Incident Response -> Alerts
1. Pick any alert that has the name **Traffic to C&C from 10.135.6.5 detected**
1. Click the blue chat bubble in the upper right-hand corner to open the "Workspace"
    * Under Comments you will the message indicating that **vm-harry-pc** was shutdown by the Block C&C playbook
1. Click the Recommendations tab - the system has correlated similar records
    1. Under Similar Records
        1. Check Select all
        1. Check Include this record
1. Click Playbooks and Select "Escalate"
1. Escalate
    1. Incident Name: Enter `C&C from vm-harry-pc`
    1. Severity: Select `Critical`
    1. Incident Lead: Select `CS Admin (me)`
    1. Escalation Reason: Pre-populated ***Alert needs to be investigated***
    1. Incident Type: Select `Malware`
    1. Closure Reason: Select `Escalated to Incident`

### Task 2 Incident Response

1. Click on Incident Response -> Incidents
1. Click on "C&C from vm-harry-pc"
1. Open "Workspace" (blue chat bubble in the upper right-hand corner)
1. Scroll through the Incident and notice how it differs from the one alert (hint: scroll down and check out correlations)
1. Run Playbook - Incident Response Plan (Type C&C) <- Playbook could also be triggered automatically
1. Identify Delivery Vector: Select `Other`
1. Click "Save"
1. Identify Target System: Enter `vm-harry-pc`
1. Click "Save"
1. Click "No Binary Found"

    * Comments section in Workspace will populate with Playbook progress

    ![FortiSOAR Incident Response](images/fsr-incident-response-01.jpg)
    ![FortiSOAR Incident Response](images/fsr-incident-response-02.jpg)
    ![FortiSOAR Incident Response](images/fsr-incident-response-03.jpg)
    ![FortiSOAR Incident Response](images/fsr-incident-response-04.jpg)
    ![FortiSOAR Incident Response](images/fsr-incident-response-05.jpg)
    ![FortiSOAR Incident Response](images/fsr-incident-response-06.jpg)
    ![FortiSOAR Incident Response](images/fsr-incident-response-07.jpg)
    ![FortiSOAR Incident Response](images/fsr-incident-response-08.jpg)
    ![FortiSOAR Incident Response](images/fsr-incident-response-09.jpg)
    ![FortiSOAR Incident Response](images/fsr-incident-response-10.jpg)
    ![FortiSOAR Incident Response](images/fsr-incident-response-11.jpg)
    ![FortiSOAR Incident Response](images/fsr-incident-response-12.jpg)
    ![FortiSOAR Incident Response](images/fsr-incident-response-13.jpg)
    ![FortiSOAR Incident Response](images/fsr-incident-response-14.jpg)

This is how customers use FortiSOAR: The Orchestration of Technology, process, and people.
