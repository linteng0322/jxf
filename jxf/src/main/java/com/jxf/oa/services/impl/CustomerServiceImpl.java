package com.jxf.oa.services.impl;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.jxf.oa.bean.Page;
import com.jxf.oa.dao.CustomerDAO;
import com.jxf.oa.entity.Customer;
import com.jxf.oa.services.CustomerService;

/**
 * Description Here
 *
 * @author Michael
 */
@Service("customerService")
public class CustomerServiceImpl extends BaseServiceImpl implements CustomerService {
	 @Autowired  
	 private HttpSession session;  
	 
	 @Autowired  
	 private CustomerDAO customerDAO;

	@Override
	public UserDetails loadUserByUsername(String arg0) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Page<Customer> findAllCustomer(int pageIndex, int pageSize,int userId) {
		// TODO Auto-generated method stub
		return customerDAO.findCustomer(pageIndex, pageSize, userId);
	}

	@Override
	public List<Customer> findCustomersBySearchtext(String searchText) {
		// TODO Auto-generated method stub
		return customerDAO.findCustomersBySearchtext(searchText);
	}
	 
}
