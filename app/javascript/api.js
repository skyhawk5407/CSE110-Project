/**
 * Contains definitions of front-end API endpoints
 */

const axios = require("axios");

axios.defaults.baseURL = "/api/v1";

export default {
  // Example endpoint
  example: {
    // Post to api/v1/example, providing the name
    post: name =>
      axios.post("/example", {
        name: name
      })
  },

  users: {
    login: {
      get: (email, password) =>
        axios.get("/users/login", {
          headers: {
            email: email,
            password: password
          }
        })
    },

    register: {
      post: (email, password, display_name, phone_number) =>
        axios.post("/users", {
          email: email,
          password: password,
          display_name: display_name,
          phone_number: phone_number
        })
    },

    delete_account: {
      delete: (email, password) =>
        axios.delete("/users", {
          headers: {
            email: email,
            password: password
          }
        })
    },

    update: {
      update_account: (
        email,
        password,
        new_email,
        display_name,
        phone_number
      ) =>
        axios.post(
          "users/update_profile",
          {
            email: new_email,
            display_name: display_name,
            phone_number: phone_number
          },
          {
            headers: {
              email: email,
              password: password
            }
          }
        ),

      update_password: (email, password, new_password) =>
        axios.post(
          "users/update_profile",
          {
            password: new_password
          },
          {
            headers: {
              email: email,
              password: password
            }
          }
        )
    }
  },

  reset_password: {
    issue_reset_token: email =>
      axios.post("/users/issue_reset_email", {
        email: email
      }),
    change_password: (newPassword, token) =>
      axios.post("/users/reset_password", {
        password: newPassword,
        reset_token: token
      })
  },

  // Expenses Post and Get endpoint
  expenses: {
    // Post Expense to api/v1/example, providing the name
    post: (payer_id, issuer_id, title, description, amount, email, password) =>
      axios.post(
        "/apartments/expenses",
        {
          payer_id: payer_id,
          issuer_id: issuer_id,
          title: title,
          description: description,
          amount: amount
        },
        {
          payer_id: payer_id,
          issuer_id: issuer_id,
          title: title,
          description: description,
          amount: amount,
          headers: {
            email: email,
            password: password
          }
        }
      ),
    get: (email, password) =>
      axios.get("/apartments/expenses/all", {
        headers: {
          email: email,
          password: password
        }
      }),
    delete: (expense_id, email, password) =>
      axios.delete("/apartments/expenses", {
        data: {
          expense_id: expense_id
        },
        headers: {
          email: email,
          password: password
        }
      }),
    pay: (expense_id, expense_paid, email, password) =>
      axios.post(
        "/apartments/expenses/mark_paid",
        {
          expense_id: expense_id,
          paid: expense_paid
        },
        {
          headers: {
            email: email,
            password: password
          }
        }
      )
  },
  // Read notifications endpoint
  markRead: {
    post: (ID, email, password) =>
      axios.post(
        "apartments/notifications/mark_read",
        {
          notification_ids: [ID]
        },
        {
          headers: {
            email: email,
            password: password
          }
        }
      )
  },
  // Send and get notifications endpoint
  notification: {
    // Post to api/v1/notification, providing the title, message, and anonymous
    post: (title, message, anonymous, email, password) =>
      axios.post(
        "/apartments/notifications",
        {
          title: title,
          message: message,
          anonymous: anonymous
        },
        {
          headers: {
            email: email,
            password: password
          }
        }
      ),
    get: (email, password) =>
      axios.get("apartments/notifications/all", {
        headers: {
          email: email,
          password: password
        }
      })
  },

  //Apartment creation endpoints
  apartment: {
    // Post to api/v1/apartments, providing the address and name
    post: (apartment_name, apartment_address, email, password) =>
      axios.post(
        "/apartments",
        {
          address: apartment_address,
          name: apartment_name
        },
        {
          headers: {
            email: email,
            password: password
          }
        }
      )
  },

  //Apartment join endpoints
  join: {
    post: (code, email, password) =>
      axios.post(
        "/users/join_apartment",
        {
          access_code: code
        },
        {
          headers: {
            email: email,
            password: password
          }
        }
      )
  },

  leave: {
    post: (email, password) =>
      axios.post(
        "/users/leave_apartment",
        {},
        {
          headers: {
            email: email,
            password: password
          }
        }
      )
  },

  //remove mate endpoint
  removeMate: {
    // Post to api/v1/apartments/remove_user, providing the user_id
    post: (user_id, email, password) =>
      axios.post(
        "/apartments/remove_user",
        {
          user_id: user_id
        },
        {
          headers: {
            email: email,
            password: password
          }
        }
      )
  },

  //invite endpoint
  invite: {
    // Post to api/v1/apartments/issue_invite_email, providing the email
    post: (invite_email, email, password) =>
      axios.post(
        "/apartments/issue_invite_email",
        {
          email: invite_email
        },
        {
          headers: {
            email: email,
            password: password
          }
        }
      )
  },

  //get current apartment endpoint
  getApt: {
    // Post to api/v1/apartments
    get: (email, password) =>
      axios.get("/apartments", {
        headers: {
          email: email,
          password: password
        }
      })
  },

  document: {
    post: (
      expense_id,
      title,
      filename,
      apartmentwide,
      file_data,
      email,
      password
    ) =>
      axios.post(
        "/apartments/documents/upload",
        {
          expense_id: expense_id,
          title: title,
          filename: filename,
          apartmentwide: apartmentwide,
          file_data: file_data
        },
        {
          headers: {
            email: email,
            password: password
          }
        }
      ),
    // Unused for now
    download: (documentId, email, password) =>
      axios.get("/apartments/documents/download", {
        params: {
          document_id: documentId
        },
        headers: {
          email: email,
          password: password
        }
      }),
    all: (email, password) =>
      axios.get("/apartments/documents/all", {
        headers: {
          email: email,
          password: password
        }
      }),
    delete: (document_id, email, password) =>
      axios.delete("/apartments/documents", {
        data: {
          document_id: document_id
        },
        headers: {
          email: email,
          password: password
        }
      })
  },
  items: {
    post: (owner_id, name, description, bought, email, password) =>
      axios.post(
        "/apartments/items",
        {
          owner_id: owner_id,
          name: name,
          description: description,
          bought: bought
        },
        {
          owner_id: owner_id,
          name: name,
          description: description,
          bought: bought,
          headers: {
            email: email,
            password: password
          }
        }
      ),
    get: (email, password) =>
      axios.get("/apartments/items/all", {
        headers: {
          email: email,
          password: password
        }
      }),
    delete: (item_id, email, password) =>
      axios.delete("/apartments/items", {
        data: {
          item_id: item_id
        },
        headers: {
          email: email,
          password: password
        }
      }),
    update: (item_id, owner_id, name, description, bought, email, password) =>
      axios.post(
        "/apartments/items/update",
        {
          item_id: item_id,
          owner_id: owner_id,
          name: name,
          description: description,
          bought: bought
        },
        {
          item_id: item_id,
          owner_id: owner_id,
          name: name,
          description: description,
          bought: bought,
          headers: {
            email: email,
            password: password
          }
        }
      )
  },
  editApartmentDetails: {
    //POST api/v1/apartments/update_description
    post: (name, address, email, password) =>
      axios.post(
        "apartments/update_description",
        {
          name: name,
          address: address
        },
        {
          headers: {
            email: email,
            password: password
          }
        }
      )
  }
};
