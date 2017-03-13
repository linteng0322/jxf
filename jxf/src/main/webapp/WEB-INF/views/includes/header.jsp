<!-- BEGIN TITLEBAR -->
<script type="text/javascript">
	/* $.ajax({
		type : "POST",
		dataType : "text",
		url : "${pageContext.request.contextPath}/sysconf/getcompanyname",
		//data:"",
		contentType : "text/html; charset=utf-8",
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			//alert(XMLHttpRequest.status);
			//alert(XMLHttpRequest.readyState);
			//alert(textStatus);
			alert("Get company name error!");
		},
		success : function(data) {
			$("#companyname").html(data);
		}
	}); */
</script>
<header id="titlebar">
	<ul id="companylogo"
		style="position: relative; top: 30px; margin-right: 20px; float: left; ">
		<label style="font-size: 40px;" id="companyname"></label>
	</ul>
	<ul id="top_menu">
		<li id="erp"><a href="/jxf/erp"><sp:message code="app.login" /></a>
			<ul class="dropdown-menu" role="menu">
				<li><a href="<c:url value="/logout"/>"> <sp:message
							code="app.logout" />
				</a></li>
			</ul></li>
	</ul>


</header>