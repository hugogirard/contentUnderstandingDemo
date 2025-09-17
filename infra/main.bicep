targetScope = 'subscription'

param resourceGroupName string
@allowed([
  'westus'
  'eastus2'
])
param location string

@minLength(4)
param storageAccountName string

resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: location
}

var suffix = uniqueString(rg.id)
var accountName = 'foundry-${suffix}'

// Storage needed for the Content Understanding
module storage 'br/public:avm/res/storage/storage-account:0.26.2' = {
  params: {
    name: storageAccountName
    publicNetworkAccess: 'Enabled'
    allowSharedKeyAccess: true
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
  scope: rg
}

module ai 'modules/ai.bicep' = {
  scope: rg
  params: {
    location: location
    accountName: accountName
    storageAccountResourceName: storage.outputs.name
  }
}
