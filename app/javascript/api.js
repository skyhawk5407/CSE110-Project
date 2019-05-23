/**
 * Contains definitions of front-end API endpoints
 */

const axios = require('axios');

axios.defaults.baseURL = '/api/v1';

export default {
  // Example endpoint
  example: {
    // Post to api/v1/example, providing the name
    post: (name) => axios.post('/example',
        {name: name})
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

    // Splitter endpoint
    expenses: {
      // Post to api/v1/example, providing the name
      post: (name) => axios.post('/apartments/expenses',
          {name: name})
    },
}