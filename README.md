# README

This is the first in a series of projects created by Rebase to help me study many tools, gems, etc.

This project will help me study:
- GraphQL
- Stripe
- Rabbit
- Ngrok

This project will connect to Projet_One to access my database and get information of my policies, create/update a policy through a Rabbit event or update a policy's payment with Rabbit event and Stripe.

I also created a webhook in StripeController to handle some stripe's events for my policy payment.

## SETUP

## Docker
Create the application container
```
make build
```

To access the container bash
```
make bash
```

Run the container:
```
make server
```

## Env file
To run this application properly, you will need to set the .env variables.
Copy the env.example file and set all variables.

To test it locally you will need to change Ngrok and Stripe variables from your personal account from both Ngrok and Stripe.

## GRAPHQL

### Header
To access the GRAPHQL route you will need a JWT TOKEN.
```
{
  'Content-Type' => 'application/json',
  'Authorization' => "Bearer #{jwt_token}"
}
```
To generate the JWT token you will need to set the JWT_SECRET, it needs to be the same token of Project_three, which will access GRAPHQL route to create/access the policy.

## Create a policy

To create a policy you will use the payload above:

Payload:
```
<<-GRAPHQL
  mutation {
    createPolicy(
      policy: {
        effectiveFrom: "2022-03-15"
        effectiveUntil: "2023-03-15"
        insuredPerson: {
          name: "Maria Silva",
          document: "111.111.111-11",
          email: "maria@email.com"
        }
        vehicle: {
          brand: "Volkswagen"
          vehicleModel: "Gol 1.6"
          year: "2022"
          licensePlate: "ABC-1111"
        }
      }
    ) { response }
  }
GRAPHQL
```

You will also need Rabbit's Docker Container of Project_One running, it will be responsable for the policy creation.

## Get Policy Information

### All Policies
To get all policies you will use the payload above:

```
 <<-GRAPHQL
  query {
    policiesQuery {
      effectiveFrom
      effectiveUntil
      status
      insuredPerson {
        name
        email
        document
      }
      vehicle {
        brand
        vehicleModel
        year
        licensePlate
      }
      payment {
        status
        link
        price
      }
    }
  }
GRAPHQL
```

### By email
To Get a policies' information given an email you will use the payload above:
```
 <<-GRAPHQL
  query {
    policiesByEmailQuery(email: #{policy_user_email}) {
      effectiveFrom
      effectiveUntil
      status
      insuredPerson {
        name
        email
        document
      }
      vehicle {
        brand
        vehicleModel
        year
        licensePlate
      }
      payment {
        status
        link
        price
      }
    }
  }
GRAPHQL
```

### By Policy ID
To get a policy by it's id use the payload above:
```
 <<-GRAPHQL
  query {
    policyQuery(id: #{policy_id}) {
      effectiveFrom
      effectiveUntil
      status
      insuredPerson {
        name
        email
        document
      }
      vehicle {
        brand
        vehicleModel
        year
        licensePlate
      }
      payment {
        status
        link
        price
      }
    }
  }
GRAPHQL
```
