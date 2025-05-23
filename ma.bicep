@description('Name of the web app (must be globally unique)')
param appName string

@description('Location for resources')
param location string = resourceGroup().location

@description('Name of the GitHub repo in the format "username/repo"')
param repoUrl string

@description('Branch of the repo to deploy')
param branch string = 'main'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${appName}-plan'
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

resource sourceControl 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = {
  name: '${webApp.name}/web'
  properties: {
    repoUrl: 'https://github.com/${repoUrl}'
    branch: branch
    isManualIntegration: true
  }
  dependsOn: [
    webApp
  ]
}

output appUrl string = 'https://${webApp.properties.defaultHostName}'
