<!-- successModal.jsp -->
<div id="successModal" class="modal hidden">
	<div class="modal-content">
		<h2 class="success-title">
			<%= request.getAttribute("modalTitle") != null ? request.getAttribute("modalTitle") : "Success!" %>
		</h2>
		<div id="successDetails" class="success-details">
			<%= request.getAttribute("modalMessage") != null ? request.getAttribute("modalMessage") : "" %>
		</div>
		<button onclick="closeSuccessModal()" class="btn btn-primary">OK</button>
	</div>
</div>

<script>
	function closeSuccessModal() {
		document.getElementById("successModal").classList.add("hidden");
	}
	function showSuccessModal() {
		document.getElementById("successModal").classList.remove("hidden");
	}
</script>
