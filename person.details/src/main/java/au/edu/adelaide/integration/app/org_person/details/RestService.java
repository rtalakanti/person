package au.edu.adelaide.integration.app.org_person.details;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.Consumes;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import au.edu.adelaide.integration.app.person.details.model.ADDRESSES;
import au.edu.adelaide.integration.app.person.details.model.ErrorMessage;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;

import io.swagger.v3.oas.annotations.security.SecurityScheme;

@SecurityScheme(name = "student_auth", type = SecuritySchemeType.HTTP, description = "Expects the header: \"Authorization: Bearer &lt;JWT token&gt;\"", scheme = "bearer")
public interface RestService {

	@Operation(summary = "Returns students' Details.", description = "", security = {
			@SecurityRequirement(name = "student_auth", scopes = {}) }, tags = { "person" })
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "An list of addresses", content = @Content(schema = @Schema(implementation = ADDRESSES.class))),
			@ApiResponse(responseCode = "400", description = "Invalid input", content = @Content(schema = @Schema(implementation = ErrorMessage.class))),
			@ApiResponse(responseCode = "401", description = "You are not authorized to submit the request", content = @Content(schema = @Schema(implementation = ErrorMessage.class))),
			@ApiResponse(responseCode = "403", description = "You do not have permission to submit the request", content = @Content(schema = @Schema(implementation = ErrorMessage.class))),
			@ApiResponse(responseCode = "404", description = "Resource is not found", content = @Content(schema = @Schema(implementation = ErrorMessage.class))),
			@ApiResponse(responseCode = "405", description = "Method Not Allowed"),
			@ApiResponse(responseCode = "406", description = "Not Acceptable"),
			@ApiResponse(responseCode = "500", description = "Unable to process the request", content = @Content(schema = @Schema(implementation = ErrorMessage.class))) })
	@Path("/person/{employeeId}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public ADDRESSES getPersonDetails(
			@Parameter(in = ParameterIn.PATH, description = "The numerical part of the employee/student id", required = true, schema = @Schema()) String employeeId);

	@Operation(summary = "Returns students' Details.", description = "", security = {
			@SecurityRequirement(name = "student_auth", scopes = {}) }, tags = { "person" })
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "An list of addresses", content = @Content(schema = @Schema(implementation = ADDRESSES.class))),
			@ApiResponse(responseCode = "400", description = "Invalid input", content = @Content(schema = @Schema(implementation = ErrorMessage.class))),
			@ApiResponse(responseCode = "401", description = "You are not authorized to submit the request", content = @Content(schema = @Schema(implementation = ErrorMessage.class))),
			@ApiResponse(responseCode = "403", description = "You do not have permission to submit the request", content = @Content(schema = @Schema(implementation = ErrorMessage.class))),
			@ApiResponse(responseCode = "404", description = "Resource is not found", content = @Content(schema = @Schema(implementation = ErrorMessage.class))),
			@ApiResponse(responseCode = "405", description = "Method Not Allowed"),
			@ApiResponse(responseCode = "406", description = "Not Acceptable"),
			@ApiResponse(responseCode = "500", description = "Unable to process the request", content = @Content(schema = @Schema(implementation = ErrorMessage.class))) })
	@Path("/student/{employeeId}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public ADDRESSES getStudentDetails(
			@Parameter(in = ParameterIn.PATH, description = "The numerical part of the employee/student id", required = true, schema = @Schema()) String employeeId);

}
