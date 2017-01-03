package com.jxf.oa.services.impl;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.jxf.oa.bean.Page;
import com.jxf.oa.dao.TransactionDAO;
import com.jxf.oa.entity.Transaction;
import com.jxf.oa.services.TransactionService;

/**
 * Description Here
 *
 * @author Michael
 */
@Service("transactionService")
public class TransactionServiceImpl extends BaseServiceImpl implements TransactionService {
	 @Autowired  
	 private HttpSession session;  
	 
	 @Autowired  
	 private TransactionDAO transactionDAO;

	@Override
	public UserDetails loadUserByUsername(String arg0) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Page<Transaction> findAllTransaction(int pageIndex, int pageSize,int userId) {
		// TODO Auto-generated method stub
		return transactionDAO.findTransaction(pageIndex, pageSize, userId);
	}

	@Override
	public Page<Transaction> findTransactionListByExample(int pageIndex, int pageSize, Transaction transaction,
			Integer id) {
		// TODO Auto-generated method stub
		return transactionDAO.findTransactionListByExample(pageIndex, pageSize, transaction, id);
	}
	
	
	 
}
