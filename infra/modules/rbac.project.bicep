// @description('Built-in Role: [Storage Blob Data Contributor]')
// resource storage_blob_data_contributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
//   name: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
//   scope: subscription()
// }

// module storage_blob_data_contributor_project 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (!empty(userObjectId)) {
//   name: 'storage_blob_data_contributor_user'
//   params: {
//     principalId: userObjectId
//     resourceId: storageResourceId
//     roleDefinitionId: storage_blob_data_contributor.id
//   }
// }
