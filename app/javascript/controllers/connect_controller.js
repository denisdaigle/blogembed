import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["thankyou", "form"]
	
	submit()	{
		this.thankyouTarget.textContent = "Thank you! An email is on its way!"
		this.formTarget.classList.add("hidden")
	}
}