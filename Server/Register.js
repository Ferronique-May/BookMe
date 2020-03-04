const RegisterForm = document.querySelector('#RegisterForm');
const msg = document.querySelector('#msg');
const FullName = document.querySelector('#FullName');
const LastName = document.querySelector('#LastName');
const Email = document.querySelector('#Email');
const Password = document.querySelector('#Password');
const ConfirmPassword = document.querySelector('#ConfirmPassword');

RegisterForm.addEventListener('Submit', onsubmit);

if (FullName.value === '' || LastName.value === '' || Email.value === '' || Password.value === ''|| ConfirmPassword.value === '')
{
    msg.innerHTML = 'Please Enter All Fields';
}
else if (FullName.value === '')
{
    msg.innerHTML = 'Please Enter Your FullName';
}
else if (LastName === '')
{
    msg.innerHTML = 'Please Enter Your LastName';
}
else if (Email.value === '')
{
    msg.innerHTML = 'Please Enter Your Email Address';
}
else if (Password.value === '' || Password.length < 8)
{
    msg.innerHTML = 'Please Your Password that is 8 characters long with One Upper case, special character and a number';
}
else if (ConfirmPassword.value === '' || Password.value != ConfirmPassword)
{
    msg.innerHTML = 'Confirm Password can not be empty/Confirm Password should match with Password';
}

