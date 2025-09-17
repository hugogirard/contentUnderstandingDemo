param accountName string
param location string
param storageAccountResourceName string

resource storage 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: storageAccountResourceName
}

#disable-next-line BCP036
resource account 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' = {
  name: accountName
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'AIServices'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    allowProjectManagement: true
    customSubDomainName: accountName
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Enabled'
    networkInjections: null
    // true is not supported today
    disableLocalAuth: false
  }
}

// Creates the Azure Foundry connection to your Azure Storage account
resource connection 'Microsoft.CognitiveServices/accounts/connections@2025-04-01-preview' = {
  name: storage.name
  parent: account
  properties: {
    category: 'AzureStorageAccount'
    target: storage.id
    authType: 'AAD'
    isSharedToAll: true
    metadata: {
      ApiType: 'Azure'
      ResourceId: storage.id
    }
  }
}

resource project 'Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview' = {
  parent: account
  name: 'contoso'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    description: 'Knowledge project'
    displayName: 'contoso'
  }
}

output projectManagedIdentityMSI string = project.identity.principalId
