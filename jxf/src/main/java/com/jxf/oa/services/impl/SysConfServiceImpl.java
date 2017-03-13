package com.jxf.oa.services.impl;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.jxf.oa.services.SysConfService;

/**
 * Description Here
 *
 * @author Michael
 */
@Service("sysconfService")
public class SysConfServiceImpl extends BaseServiceImpl implements SysConfService {
	 @Autowired  
	 private HttpSession session;

	@Override
	public UserDetails loadUserByUsername(String arg0) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}
}
