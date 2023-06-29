##### Written by:       Jesse Dickens
##### Date Created:     6/9/23                  
##### Date Modified:    6/9/23
##### Purpose:          First attempt to audit MX info using the API            

#import modules
import meraki
import os

#define dashboard and import API key from environment variable
dashboard = meraki.DashboardAPI(os.getenv('MERAKI_DASHBOARD_API_KEY'))

response = dashboard.organizations.getOrganizations()

print(response)

