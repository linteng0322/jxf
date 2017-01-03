package com.jxf.oa.services.impl;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.jxf.oa.bean.Page;
import com.jxf.oa.dao.MaterialOrderDAO;
import com.jxf.oa.entity.MaterialOrder;
import com.jxf.oa.services.MaterialOrderService;

/**
 * Description Here
 *
 * @author Michael
 */
@Service("materialOrderService")
public class MaterialOrderServiceImpl extends BaseServiceImpl implements MaterialOrderService {
	 @Autowired  
	 private HttpSession session;  
	 
	 @Autowired  
	 private MaterialOrderDAO materialOrderDAO;

	@Override
	public UserDetails loadUserByUsername(String arg0) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Page<MaterialOrder> findAllMaterialOrder(int pageIndex, int pageSize,int userId) {
		// TODO Auto-generated method stub
		return materialOrderDAO.findMaterialOrder(pageIndex, pageSize, userId);
	}
	 
}
