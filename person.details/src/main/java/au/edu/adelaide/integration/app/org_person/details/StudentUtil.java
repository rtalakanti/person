package au.edu.adelaide.integration.app.org_person.details;

import org.apache.cxf.common.util.Base64Utility;
import org.springframework.stereotype.Component;

@Component
public class StudentUtil {


	/**
	 * This method is using for create base64 header.
	 * @param username
	 * @param password
	 * @return
	 */
	public  String getAuthHeader(String username, String password) {
		String authorizationHeader = null;
		String authPayload = username + ":" + password;
		authorizationHeader = "Basic " + Base64Utility.encode(authPayload.getBytes());
		return authorizationHeader;
	}

}
