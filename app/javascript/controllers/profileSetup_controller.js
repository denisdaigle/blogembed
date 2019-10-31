import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["firstNameInput", "lastNameInput", "passwordInput", "firstNameError", "lastNameError", "passwordError", "form", "thankYou", "thankYouMessageHolder"]
	
	submit(event) {
		
		//hide all errors that may be open.
		this.firstNameErrorTarget.classList.add("hidden")
		this.lastNameErrorTarget.classList.add("hidden")
		this.passwordErrorTarget.classList.add("hidden")
		
		if(this.firstNameInputTarget.value == ""){
			//inform the user.
			this.firstNameErrorTarget.textContent = "Please provide your first name"
			this.firstNameErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else if(this.lastNameInputTarget.value == ""){
			//inform the user.
			this.lastNameErrorTarget.textContent = "Please provide your last name"
			this.lastNameErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else if(this.passwordInputTarget.value == ""){
			//inform the user.
			this.passwordErrorTarget.textContent = "Please provide a password"
			this.passwordErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else if (this.validatePassword() == false) {
			//inform the user.
			this.passwordErrorTarget.textContent = "Must have a space and be longer than 8 characters. Try a short, memorable phrase."
			this.passwordErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else {
			//allow form submit.
			this.thankYouTarget.textContent = "Thank you " + this.firstNameInputTarget.value + ", one moment please"
			this.thankYouMessageHolderTarget.classList.remove("hidden")
			this.formTarget.classList.add("hidden")
		}

	}

	validatePassword(){
	
		//Validate email format before sending
		//^                         Start anchor
        //(?=.*[A-Z].*[A-Z])        Ensure string has two uppercase letters.
        //(?=.*[!@#$&*])            Ensure string has one special case letter.
        //(?=.*[0-9].*[0-9])        Ensure string has two digits.
        //(?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
        //.{8,100}                  Ensure string is between 8 and 100 characters.
        //(?=.*[ ])					Ensure a blank space is used with other characters, as in a password phrase
        //(?=.*[a-zA-Z0-9!@#$&*].*[ ].*[a-zA-Z0-9!@#$&*]) Ensures you must basically a memorable, basic or strong phrase. An uppercase letter or a lowercase character, or a number, or a special character AND and space, then an uppercase letter or a lowercase character, or a number, or a special character. 
        //$                         End anchor.

		var password_validator = new RegExp('(?=.*[a-zA-Z0-9!@#$&*].*[ ].*[a-zA-Z0-9!@#$&*]).{8,100}$');
            
		if (password_validator.test(this.passwordInputTarget.value)) {
			//if there is a match, return true, it's valid
			return true
		} else {
			return false
		}
	
	}
} 