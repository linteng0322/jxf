package com.jxf.oa.dao;

import org.hibernate.Criteria;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Transaction;

public interface TransactionDAO extends BaseDAO {
    
	public int findTotalSize(Criteria criteria);

    public Page<Transaction> findTransaction(int pageIndex, int pageSize, int userId);

	public Page<Transaction> findTransactionListByExample(int pageIndex, int pageSize, Transaction transaction,
			Integer id);
    
}
