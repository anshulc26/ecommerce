$.validator.addMethod(
  "noSpace",
  function (value, element) {
    return value.trim().length > 0
  },
  "Please enter some value either than only space"
)

$(document).on("turbolinks:load", function () {
  if ($("#signin_user").length > 0) {
    $("#signin_user").validate({
      errorPlacement: function (error, element) {
        error.insertAfter(element)
      },
      rules: {
        "user[email]": {
          required: true,
          noSpace: true,
          maxlength: 255,
        },
        "user[password]": {
          required: true,
          noSpace: true,
          minlength: 6,
          maxlength: 255,
        },
      },
      messages: {
        "user[email]": {
          required: "Please enter your email.",
          noSpace: "Please enter valid email.",
        },
        "user[password]": {
          required: "Please enter your password.",
          noSpace: "Please enter valid password.",
          minlength: "Your password must be of minimum 6 characters.",
          maxlength: "Your password must be of maximum 255 characters.",
        },
      },
    })
  }

  if ($("#signup_user").length > 0) {
    $("#signup_user").validate({
      errorPlacement: function (error, element) {
        error.insertAfter(element)
      },
      rules: {
        "user[user_type]": {
          required: true,
        },
        "user[name]": {
          required: true,
          noSpace: true,
          maxlength: 255,
        },
        "user[email]": {
          required: true,
          noSpace: true,
          email: true,
          maxlength: 255,
          remote: {
            url: "/check_email_unique",
            type: "get",
          },
        },
        "user[password]": {
          required: true,
          noSpace: true,
          minlength: 6,
          maxlength: 255,
        },
        "user[password_confirmation]": {
          required: true,
          noSpace: true,
          minlength: 6,
          maxlength: 255,
          equalTo: "#signup_user_password",
        },
        "user[state_code]": {
          required: true,
        },
      },
      messages: {
        "user[user_type]": {
          required: "Please select user type.",
        },
        "user[name]": {
          required: "Please enter your name.",
          noSpace: "Please enter valid name.",
        },
        "user[email]": {
          required: "Please enter your email.",
          noSpace: "Please enter valid email.",
          email: "Please enter valid email.",
          remote: "This email is taken.",
        },
        "user[password]": {
          required: "Please enter your password.",
          noSpace: "Please enter valid password.",
          minlength: "Your password must be of minimum 6 characters.",
          maxlength: "Your password must be of maximum 255 characters.",
        },
        "user[password_confirmation]": {
          required: "Please confirm your password.",
          noSpace: "Please enter valid confirm password.",
          minlength: "Your confirm password must be of minimum 6 characters.",
          maxlength: "Your confirm password must be of maximum 255 characters.",
          equalTo: "Your confirm password must be same as password.",
        },
        "user[state_code]": {
          required: "Please select state.",
        },
      },
    })
  }

  if ($("#forgot_password_new").length > 0) {
    $("#forgot_password_new").validate({
      errorPlacement: function (error, element) {
        error.insertAfter(element)
      },
      rules: {
        "user[email]": {
          required: true,
          email: true,
          noSpace: true,
          maxlength: 255,
        },
      },
      messages: {
        "user[email]": {
          required: "Please enter your email.",
          email: "Please enter valid email.",
          noSpace: "Please enter valid email.",
        },
      },
    })
  }

  if ($("#forgot_password_edit").length > 0) {
    $("#forgot_password_edit").validate({
      errorPlacement: function (error, element) {
        error.insertAfter(element)
      },
      rules: {
        "user[password]": {
          required: true,
          noSpace: true,
          minlength: 6,
          maxlength: 255,
        },
        "user[password_confirmation]": {
          required: true,
          noSpace: true,
          minlength: 6,
          maxlength: 255,
          equalTo: "#new_password",
        },
      },
      messages: {
        "user[password]": {
          required: "Please enter your password.",
          noSpace: "Please enter valid password.",
          minlength: "Your password must be of minimum 6 characters.",
          maxlength: "Your password must be of maximum 255 characters.",
        },
        "user[password_confirmation]": {
          required: "Please confirm your password.",
          noSpace: "Please enter valid confirm password.",
          minlength: "Your confirm password must be of minimum 6 characters.",
          maxlength: "Your confirm password must be of maximum 255 characters.",
          equalTo: "Your confirm password must be equal to password.",
        },
      },
    })
  }

  if ($("#product_form").length > 0) {
    $("#product_form").validate({
      errorPlacement: function (error, element) {
        error.insertAfter(element)
      },
      rules: {
        "product[name]": {
          required: true,
          noSpace: true,
          maxlength: 255,
        },
        "product[sku]": {
          required: true,
          noSpace: true,
          maxlength: 255,
        },
        "product[price]": {
          required: true,
          number: true,
        },
        "product[quantity]": {
          required: true,
          digits: true,
        },
      },
      messages: {
        "product[name]": {
          required: "Please enter name.",
          noSpace: "Please enter valid name.",
        },
        "product[sku]": {
          required: "Please enter sku.",
          noSpace: "Please enter valid sku.",
        },
        "product[price]": {
          required: "Please enter price.",
        },
        "product[quantity]": {
          required: "Please enter quantity.",
        },
      },
    })
  }
})
