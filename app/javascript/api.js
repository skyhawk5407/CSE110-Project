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
    post: (email, password, display_name) => axios.post('/users', {
      email: email,
      password: password,
      display_name: display_name
    })
  },

  // Expenses Post and Get endpoint
  expenses: {
    // Post Expense to api/v1/example, providing the name
    post: (payer_id, issuer_id, title, amount) => axios.post('/apartments/expenses', {
      payer_id: payer_id,
      issuer_id: issuer_id,
      title: title,
      amount: amount
    }, {
      headers: {
        email: 'jsmith@example.com',
        password: 'password123'
      }
    }),
    get: (email, password) => axios.get('/apartments/expenses/all', {
      headers: {
        email: email,
        password: password
      }
    })
  },
}