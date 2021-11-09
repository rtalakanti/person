package au.edu.adelaide.integration.app.org_person.details;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.xml.namespace.QName;

import org.apache.camel.component.cxf.CxfEndpoint;
import org.apache.camel.component.cxf.common.header.CxfHeaderFilterStrategy;
import org.apache.camel.component.cxf.jaxrs.CxfRsEndpoint;
import org.apache.cxf.Bus;
import org.apache.cxf.BusFactory;
import org.apache.cxf.jaxrs.JAXRSServerFactoryBean;
import org.apache.cxf.jaxrs.client.JAXRSClientFactoryBean;
import org.apache.cxf.ws.security.wss4j.WSS4JOutInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import au.edu.adelaide.integration.util.cxf.logging.UOALoggingFeature;
import au.edu.adelaide.integration.util.cxf.security.PasswordCallbackHandler;

@Configuration
public class ApplicationConfiguration {

	@Value("${app.name}")
	String appName;

	@Value("${rest.service.address}")
	private String serviceAddress;

	@Value("${peoplesoft.service.url}")
	private String peopleSoftServiceAddress;

	@Value("${secure.field.status:true}")
	private String secureFieldStatus;

	@Autowired
	private Bus bus;

	@Bean
	public Bus bus() {
		Bus bus = BusFactory.getDefaultBus();
		ArrayList<UOALoggingFeature> loggingFeatures = new ArrayList<UOALoggingFeature>();
		loggingFeatures.add(loggingFeature());
		bus.setFeatures(loggingFeatures);
		return bus;
	}

	@Bean
	public UOALoggingFeature loggingFeature() {
		UOALoggingFeature loggingFeature = new UOALoggingFeature(Boolean.parseBoolean(secureFieldStatus));
		loggingFeature.setPrettyLogging(true);
		return loggingFeature;
	}

	
	@Bean(name = "personDataServiceEndpoint")
	JAXRSServerFactoryBean personDataServiceEndpoint() {
	
		CxfRsEndpoint endpoint = new CxfRsEndpoint();
		JAXRSServerFactoryBean rsServer = endpoint.createJAXRSServerFactoryBean();
		rsServer.setBus(bus);
		rsServer.setServiceClass(RestService.class);
		rsServer.setAddress(serviceAddress);
		
		return rsServer;

	}
	// peoplesoft rest client


	@Bean
	JAXRSClientFactoryBean peopleSoftRestClient() {

		final Map<String, Object> properties = new HashMap<>();
		properties.put("inheritHeaders", true);
		properties.put("loggingFeatureEnabled", false);
		properties.put("loggingSizeLimit", 200);
		final JAXRSClientFactoryBean rsClient = new CxfRsEndpoint().createJAXRSClientFactoryBean();
		rsClient.setAddress(peopleSoftServiceAddress);
		rsClient.setProperties(properties);
		return rsClient;
	}

}
