package com.jxf.oa.services.impl;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.jxf.oa.bean.Page;
import com.jxf.oa.dao.MemoDAO;
import com.jxf.oa.entity.Memo;
import com.jxf.oa.services.MemoService;

/**
 * Description Here
 *
 * @author Michael
 */
@Service("memoService")
public class MemoServiceImpl extends BaseServiceImpl implements MemoService {
	 @Autowired  
	 private HttpSession session;  
	 
	 @Autowired  
	 private MemoDAO memoDAO;

	@Override
	public UserDetails loadUserByUsername(String arg0) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Page<Memo> findAllMemo(Integer page, int pageSize, Integer userId) {
		// TODO Auto-generated method stub
		return memoDAO.findAllMemo(page, pageSize, userId);
	}

	@Override
	public List<Memo> findMemoListByExample(Memo memo, Integer userId) {
		// TODO Auto-generated method stub
		return memoDAO.findMemoListByExample(memo, userId);
	}

}
