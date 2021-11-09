package au.edu.adelaide.integration.app.org_person.details.routes;

import org.apache.camel.Exchange;
import org.apache.camel.LoggingLevel;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.cxf.common.message.CxfConstants;

import org.apache.camel.http.common.HttpMethods;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import java.nio.charset.StandardCharsets;

@Component
public class Route extends RouteBuilder {


	public static final Logger logger = LoggerFactory.getLogger(Route.class);

    @Value("${peoplesoft.service.username}")
    private String username;
    @Value("${peoplesoft.service.password}")
    private String password;
    @Value("${peoplesoft.service.path}")
    private String servicePath;

    @Override
    public void configure() throws Exception {


        onException(Exception.class)
            .log(LoggingLevel.ERROR, "Cannot Complete route at ${routeId} . Message: "
                    + "${exception.message}")
            .log(LoggingLevel.ERROR, "${exception.stacktrace}")
            .handled(true)
            .removeHeaders("*")
            .setHeader(Exchange.HTTP_RESPONSE_CODE, constant("500"))
            .setBody(simple("<PersonErrorResponse xmlns=\"http://adelaide.edu.au/integration/app/PersonDataResponse\"><Error>PersonData Service Error - ${exception.message}</Error></PersonErrorResponse>"))		
            .setHeader("Content-Type").simple("application/xml")
            .stop();
            

        from("cxfrs:bean:personDataServiceEndpoint?bindingStyle=SimpleConsumer").routeId("orgperson_service_v1_route")
                .log(LoggingLevel.INFO,logger.getName(),"Person data  Request rceived")
                .log(LoggingLevel.DEBUG,logger.getName(),"Person data  Request data ${body} ")
                .setProperty("employeeId").simple("${header.employeeId}")
                .removeHeaders("*")
                .setHeader(Exchange.HTTP_METHOD, constant(HttpMethods.GET))
                .setHeader(CxfConstants.CAMEL_CXF_RS_USING_HTTP_API, constant(Boolean.TRUE))
                .setHeader(HttpHeaders.ACCEPT, constant("application/json; encoding=\"UTF-8\""))
                .setHeader(HttpHeaders.CONTENT_TYPE, constant("application/json; encoding=\"UTF-8\""))
                .setHeader(Exchange.HTTP_PATH, simple(servicePath + "${exchangeProperty.employeeId}"))
                //.setHeader(Exchange.HTTP_PATH, simple("/students/${exchangeProperty.employeeId}/addresses"))
                .setBody(constant(""))
                .log(LoggingLevel.DEBUG, logger, "calling Peoplesoft Service to get info")
                .setHeader(HttpHeaders.AUTHORIZATION,simple("${bean:studentUtil?method=getAuthHeader("+username+","+password+ ")}"))
                .to("cxfrs:bean:peopleSoftRestClient")
                .setHeader(HttpHeaders.CONTENT_TYPE, constant(MediaType.APPLICATION_JSON))
                .convertBodyTo(String. class, StandardCharsets.UTF_8.name())
                .log(LoggingLevel.DEBUG,logger.getName()," peoplesoft address call response  ${body}");
    }
}
