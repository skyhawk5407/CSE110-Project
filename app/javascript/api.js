/**
 * Contains definitions of front-end API endpoints
 */

const axios = require('axios');

axios.defaults.baseURL = '/api/v1';

export default {
  // Example endpoint
  example: {
    // Post to api/v1/example, providing the name
    post: (name) => axios.post('/example', {
      name: name
    })
  },

  login: {
    get: (email, password) => axios.get('/users/login', {
      headers: {
        email: email,
        password: password
      }
    })
  },

  register: {
      post: (email, password, display_name, phone_number) => axios.post('/users', {
          email: email,
          password: password,
          display_name: display_name,
          phone_number: phone_number
      })
  },

  delete_account: {
      delete: (email, password) => axios.delete('/users', {
          headers: {
              email: email,
              password: password
          }
      })
  },
    

  // Expenses Post and Get endpoint
  expenses: {
    // Post Expense to api/v1/example, providing the name
    post: (payer_id, issuer_id, title, amount, email, password) => axios.post('/apartments/expenses', {
      payer_id: payer_id,
      issuer_id: issuer_id,
      title: title,
      amount: amount
    }, {
      headers: {
        email: email,
        password: password,
      }
    }),
    get: (email, password) => axios.get('/apartments/expenses/all', {
      headers: {
        email: email,
        password: password
      }
    })
  },

  // Notifications endpoint
  notification: {
    // Post to api/v1/notification, providing the subject and message
    post: (subject, message) => axios.post('/apartments/notifications', {
        subject: subject,
        message: message
        })
  },

  //Apartment creation endpoints
  apartment: {
    // Post to api/v1/apartments, providing the address and name
    post: (apartment_name, apartment_address, email, password) => axios.post('/apartments', {
      address: apartment_address,
      name: apartment_name}, {
      headers: {
        email: email,
        password: password
      }
    })
  },

  //Apartment join endpoints
  join: {
    post: (code, email, password) => axios.post('/users/join_apartment',{
      access_code: code
    }, {
      headers: {
        email:email,
        password: password
      }
    })
  }
}
