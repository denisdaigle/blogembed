import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["form", "blogNameInput", "blogNameError", "postTitleInput", "postTitleError", "postContentInput", "postContentError", "errorMessage", "errorMessageHolder", "processingMessage", "processingMessageHolder"]
	
	create(event) {
		
		//hide all errors that may be open.
		this.blogNameErrorTarget.classList.add("hidden")
		this.postTitleErrorTarget.classList.add("hidden")
		this.postContentErrorTarget.classList.add("hidden")
		this.errorMessageTarget.classList.add("hidden")
		
		if(this.blogNameInputTarget.value == ""){
			//inform the user.
			this.blogNameErrorTarget.textContent = "Please provide a name for this blog"
			this.blogNameErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else if(this.postTitleInputTarget.value == ""){
			//inform the user.
			this.postTitleErrorTarget.textContent = "Please provide a title for this post"
			this.postTitleErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else if(this.postContentInputTarget.value == ""){
			//inform the user.
			this.postContentErrorTarget.textContent = "Please provide content for this post"
			this.postContentErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else {
			//allow form submit.
			this.processingMessageTarget.textContent = "Creating. One moment please"
			this.processingMessageHolderTarget.classList.remove("hidden")
			this.formTarget.classList.add("hidden")
		}

	}

} 