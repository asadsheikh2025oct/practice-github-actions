// --- Parameters ---

@description('The prefix for the storage account name. Must be 3 to 16 characters long for the total name to be 24 characters max.')
param storageAccountPrefix string = 'stacc'

// By default, location is inferred from the deployment group, 
// but it's good practice to allow overriding or using a consistent location.
@description('The Azure region where the resources will be deployed.')
param location string = resourceGroup().location 

// --- Variables ---

// Generate a unique 8-character string based on the resource group's unique ID.
// This ensures the name is globally unique and meets naming constraints.
var uniqueSuffix = uniqueString(resourceGroup().id)

// The final storage account name, combining the prefix with the 8-character unique suffix.
var storageAccountName = '${storageAccountPrefix}${substring(uniqueSuffix, 0, 8)}'

// --- Resources ---

// Create the Azure Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  // Use the calculated unique name
  name: storageAccountName
  // Use the specified location (or the location of the resource group)
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
  }
}

// --- Outputs ---

@description('The full name of the created Storage Account.')
output storageAccountNameOutput string = storageAccount.name