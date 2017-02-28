package com.jxf.oa.services.impl;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.jxf.oa.bean.Page;
import com.jxf.oa.dao.MemoJXFOrderDAO;
import com.jxf.oa.entity.MemoJXFOrder;
import com.jxf.oa.services.MemoJXFOrderService;

/**
 * Description Here
 *
 * @author Michael
 */
@Service("memojxforderService")
public class MemoJXFOrderServiceImpl extends BaseServiceImpl implements MemoJXFOrderService {
	 @Autowired  
	 private HttpSession session;  
	 
	 @Autowired  
	 private MemoJXFOrderDAO jxforderDAO;

	@Override
	public UserDetails loadUserByUsername(String arg0) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Page<MemoJXFOrder> findAllJxfOrder(int pageIndex, int pageSize,int userId) {
		// TODO Auto-generated method stub
		return jxforderDAO.findJxfOrder(pageIndex, pageSize, userId);
	}

	@Override
	public List<MemoJXFOrder> findJxfOrderListByExample(MemoJXFOrder order, int userId) {
		// TODO Auto-generated method stub
		return jxforderDAO.findJxfOrderListByExample(order, userId);
	}
	 
}
