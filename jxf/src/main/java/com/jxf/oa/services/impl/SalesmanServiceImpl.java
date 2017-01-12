package com.jxf.oa.services.impl;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.jxf.oa.bean.Page;
import com.jxf.oa.dao.SalesmanDAO;
import com.jxf.oa.entity.Salesman;
import com.jxf.oa.services.SalesmanService;

/**
 * Description Here
 *
 * @author Michael
 */
@Service("salesmanService")
public class SalesmanServiceImpl extends BaseServiceImpl implements SalesmanService {
	 @Autowired  
	 private HttpSession session;  
	 
	 @Autowired  
	 private SalesmanDAO salesmanDAO;

	@Override
	public UserDetails loadUserByUsername(String arg0) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Page<Salesman> findAllSalesman(int pageIndex, int pageSize,int userId) {
		// TODO Auto-generated method stub
		return salesmanDAO.findSalesman(pageIndex, pageSize, userId);
	}
	 
}
