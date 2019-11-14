import {  Controller } from "stimulus"

export default class extends Controller {
    static targets = [ 'cardElement', 'cardErrors', 'form', 'upgradeButton', 'purchaseFormHolder' ]

    connect() {
        var stripe = Stripe(this.element.getAttribute("data-stripe-public-key"));
        var elements = stripe.elements();
        var style = {
            base: {
                color: '#32325d',
                fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
                fontSmoothing: 'antialiased',
                fontSize: '16px',
                '::placeholder': {
                    color: '#aab7c4'
                }
            },
            invalid: {
                color: '#fa755a',
                iconColor: '#fa755a'
            }
        };

        var card = elements.create('card', {
            style: style
        });

        card.mount(this.cardElementTarget);

        // Handle real-time validation errors from the card Element.
        let controller = this;
        card.addEventListener('change', function (event) {
            var displayError = controller.cardErrorsTarget;
            if (event.error) {
                displayError.textContent = event.error.message;
            } else {
                displayError.textContent = '';
            }
        });

        // Handle form submission.
        var form = controller.formTarget;
        form.addEventListener('submit', function (event) {
            event.preventDefault();

            stripe.createToken(card).then(function (result) {
                if (result.error) {
                    // Inform the user if there was an error.
                    var errorElement = this.cardErrorsTarget;
                    errorElement.textContent = result.error.message;
                } else {
                    // Send the token to your server.
                    controller.stripeTokenHandler(result.token);
                }
            });
        });

    }

    showPurchaseFormHolder(){
        this.upgradeButtonTarget.classList.add("hidden");
        this.purchaseFormHolderTarget.classList.remove("hidden");
    }

    // Submit the form with the token ID.
    stripeTokenHandler(token) {
        // Insert the token ID into the form so it gets submitted to the server
        var form = this.formTarget;
        var hiddenInput = document.createElement('input');
        hiddenInput.setAttribute('type', 'hidden');
        hiddenInput.setAttribute('name', 'stripeToken');
        hiddenInput.setAttribute('value', token.id);
        form.appendChild(hiddenInput);

        // Submit the form
        form.submit();
    }
    
}