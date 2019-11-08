import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["popup", "message"]
	
	connect() {
	    //this.fadeOut() //to use this, add style="opacity:1;" in the div that you're calling this one.
	}
	
// 	fadeOut() {
		
// 	    var element = this.broadcastTarget
	    
// 	    if(element.style.opacity == 1) {
// 	    	element.style.opacity -= 0.1;
// 	        setTimeout(() => this.fadeOut(), 1000) // 1 second full view time.
// 	    } else if (element.style.opacity > 0.1){
// 	    	element.style.opacity -= 0.1;
// 	    	setTimeout(() => this.fadeOut(), 50) // increase to make slower fade.
// 	    } else {
// 	    	//hide the element.
// 	    	element.classList.add("hidden")
// 			this.messageTarget.textContent = ''
// 			//reset the opacity so this is ready for reuse.
// 	    	element.style.opacity = 1;
// 	    }
		
// 	}
	
	close(event) {
		
		//hide the broadcast message
		this.popupTarget.classList.add("hidden")
		this.messageTarget.textContent = ''

	}

}	