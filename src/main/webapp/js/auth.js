document.getElementById('registerForm').addEventListener('submit',
	handleRegistration);

function handleRegistration(e) {
	e.preventDefault();

	const form = e.target;
	const formData = new FormData(form);
	const registrationData = {
		name: formData.get('name').trim(),
		email: formData.get('email').trim(),
		mobile: formData.get('mobile').trim(),
		address: formData.get('address').trim(),
		userId: formData.get('userId').trim(),
		password: formData.get('password'),
		confirmPassword: formData.get('confirmPassword'),
		preferences: formData.getAll('preferences')
	};

	clearErrors();

	const errors = validateRegistrationData(registrationData);

	if (Object.keys(errors).length > 0) {
		showErrors(errors);
		return;
	}

	// All validations passed → submit the form
	form.submit(); // this will go to RegisterServlet via POST
}

function validateRegistrationData(data) {
    const errors = {};
    
    // Name validation
    if (!data.name || data.name.length > 50) {
        errors.name = 'Name is required and must be less than 50 characters';
    }
    
    // Email validation
    if (!data.email || !validateEmail(data.email)) {
        errors.email = 'Please enter a valid email address';
    }
    
    // Mobile validation
    if (!data.mobile || !validateMobile(data.mobile)) {
        errors.mobile = 'Please enter a valid mobile number with country code';
    }
    
    // Address validation
    if (!data.address) {
        errors.address = 'Address is required';
    }
    
    // User ID validation
    if (!data.userId || !validateUsername(data.userId)) {
        errors.userId = 'User ID must be 5-20 characters long';
    }
    
    // Password validation
    if (!data.password || !validatePassword(data.password)) {
        errors.password = 'Password must include uppercase, lowercase, and special character (max 30 chars)';
    }
    
    // Confirm password validation
    if (data.password !== data.confirmPassword) {
        errors.confirmPassword = 'Passwords do not match';
    }
    
    return errors;
}


function setupRegistrationValidation() {
	// User ID validation on blur
	const userIdInput = document.getElementById('userId');
	if (userIdInput) {
		userIdInput.addEventListener('blur', function() {
			const username = this.value.trim();
			if (!validateUsername(username)) {
				showError('userId',
					'User ID must be 5–20 characters long');
			} else {
				clearError('userId');
			}
		});
	}

	// Email validation on blur
	const emailInput = document.getElementById('email');
	if (emailInput) {
		emailInput.addEventListener('blur', function() {
			const email = this.value.trim();
			if (!validateEmail(email)) {
				showError('email', 'Invalid email format');
			} else {
				clearError('email');
			}
		});
	}

	// Password validation on input
	const passwordInput = document.getElementById('password');
	if (passwordInput) {
		passwordInput
			.addEventListener(
				'input',
				function() {
					const password = this.value;
					if (!validatePassword(password)) {
						showError('password',
							'Password must include uppercase, lowercase, and special character');
					} else {
						clearError('password');
					}
				});
	}

	// Confirm Password validation on input
	const confirmPasswordInput = document
		.getElementById('confirmPassword');
	if (confirmPasswordInput) {
		confirmPasswordInput.addEventListener('input', function() {
			const password = document.getElementById('password').value;
			const confirmPassword = this.value;
			if (confirmPassword && password !== confirmPassword) {
				showError('confirmPassword', 'Passwords do not match');
			} else {
				clearError('confirmPassword');
			}
		});
	}
	
	// Mobile number validation on blur
	const mobileInput = document.getElementById('mobile');
	if (mobileInput) {
	    mobileInput.addEventListener('blur', function () {
	        const mobile = this.value.trim();
	        if (!validateMobile(mobile)) {
	            showError('mobile', 'Invalid mobile number format');
	        } else {
	            clearError('mobile');
	        }
	    });
	}

}
document.addEventListener('DOMContentLoaded',
	setupRegistrationValidation);