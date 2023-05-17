document.querySelector("#confirm").addEventListener("click",function(e){
    if(!/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/.test(password.value) ||
    password.value == "" ||
    confirmPwd.value == "" ||
    password.value != confirmPwd.value
    ){
        e.preventDefault();
        document.querySelector("#confirm-error").classList.remove("d-none");
        document.querySelector("#confirm-error").innerText = "請檢查密碼是否包含英文與數字，且至少8個字元";
    }else{
        document.querySelector("#updatePwd").submit();
    }
})

password.addEventListener("blur", function () {
    if (!/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/.test(password.value)) {
      document.querySelector("#password-error").innerText = "密碼必須包含英文與數字，且至少8個字元"
      password.classList.add("is-invalid");
    }
  });

  confirmPwd.addEventListener("blur", function () {
    if (confirmPwd.value != password.value) {
      document.querySelector("#confirmPwd-error").innerText = "與密碼不符"
      confirmPwd.classList.add("is-invalid");
    }
  });