import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["code", "content", "iframeParent"]

	toggle(event) {
		
		//hide the broadcast message
		this.codeTarget.classList.toggle("hidden")
		
		var iframe_content = this.iframeParentTarget.value
		var captured_height = this.contentTarget.clientHeight
		this.iframeParentTarget.value = iframe_content.replace('estimated_display_dimensions', 'width:100%;height:' + captured_height + 'px;')

	}

}