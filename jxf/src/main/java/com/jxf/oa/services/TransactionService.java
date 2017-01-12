package com.jxf.oa.services;

import org.springframework.security.core.userdetails.UserDetailsService;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Transaction;

/**
 * Description Here
 *
 * @author Michael
 */
public interface TransactionService extends BaseService, UserDetailsService {

	Page<Transaction> findAllTransaction(int pageIndex, int pageSize, int userId);

	Page<Transaction> findTransactionListByExample(int pageIndex, int pageSize, Transaction transaction, Integer id);
	
	
}
