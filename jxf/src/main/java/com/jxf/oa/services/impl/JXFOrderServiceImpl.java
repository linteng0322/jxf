package com.jxf.oa.services.impl;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.jxf.oa.bean.Page;
import com.jxf.oa.dao.JXFOrderDAO;
import com.jxf.oa.entity.JXFOrder;
import com.jxf.oa.services.JXFOrderService;

/**
 * Description Here
 *
 * @author Michael
 */
@Service("jxforderService")
public class JXFOrderServiceImpl extends BaseServiceImpl implements JXFOrderService {
	 @Autowired  
	 private HttpSession session;  
	 
	 @Autowired  
	 private JXFOrderDAO jxforderDAO;

	@Override
	public UserDetails loadUserByUsername(String arg0) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Page<JXFOrder> findAllJxfOrder(int pageIndex, int pageSize,int userId) {
		// TODO Auto-generated method stub
		return jxforderDAO.findJxfOrder(pageIndex, pageSize, userId);
	}

	@Override
	public List<JXFOrder> findJxfOrderListByExample(JXFOrder order, int userId) {
		// TODO Auto-generated method stub
		return jxforderDAO.findJxfOrderListByExample(order, userId);
	}
	 
}
