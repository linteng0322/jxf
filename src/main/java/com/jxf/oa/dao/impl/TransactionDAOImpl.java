package com.jxf.oa.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Component;

import com.jxf.oa.bean.Page;
import com.jxf.oa.dao.TransactionDAO;
import com.jxf.oa.entity.Transaction;
import com.jxf.oa.entity.User;

@Component
public class TransactionDAOImpl extends BaseDAOImpl implements TransactionDAO{

	    @Override
	    public int findTotalSize(Criteria criteria) {
	        criteria.setProjection(Projections.rowCount());
	        int totalSize =  ((Long)criteria.uniqueResult()).intValue();
	        criteria.setProjection(null);
	        return totalSize;
	    }

	    @Override
	    public Page<Transaction> findTransaction(int pageIndex, int pageSize, int userId) {

	        Criteria criteria = session().createCriteria(Transaction.class);
	        int totalSize = findTotalSize(criteria);
	        int totalPage = totalSize / pageSize;
	        if(totalSize % pageSize != 0) {
	            totalPage += 1;
	        }

	        if(pageIndex > totalPage) {
	            pageIndex = totalPage;
	        }

	        criteria.addOrder(org.hibernate.criterion.Order.desc("id"));
	        criteria.setFirstResult((pageIndex - 1) * pageSize);
	        criteria.setMaxResults(pageSize);

	        List<Transaction> transactions = criteria.list();

	        return new Page<Transaction>(pageIndex, totalPage, pageSize, totalSize, transactions);
       }

		@Override
		public Page<Transaction> findTransactionListByExample(int pageIndex, int pageSize, Transaction transaction,
				Integer id) {
			Criteria criteria = session().createCriteria(Transaction.class);
			if(transaction.getMaterial()!=null&&transaction.getMaterial().getId()!=null)
				criteria.add(Restrictions.eq("material", transaction.getMaterial() ));
			else if(transaction.getMaterial()!=null&&transaction.getMaterial().getMaterialId()!=null&&transaction.getMaterial().getMaterialId()!="")
				criteria.add(Restrictions.eq("material", transaction.getMaterial() ));
			if(transaction.getType()!=null&&transaction.getType()!="")
				criteria.add(Restrictions.eq("type", transaction.getType()));
			if(transaction.getOrderNo()!=null&&transaction.getOrderNo()!="")
				criteria.add(Restrictions.eq("orderNo", transaction.getOrderNo()));
      	  	//criteria.add(Restrictions.eq("mainOrder", true));
	        int totalSize = findTotalSize(criteria);
	        int totalPage = totalSize / pageSize;
	        if(totalSize % pageSize != 0) {
	            totalPage += 1;
	        }

	        if(pageIndex > totalPage) {
	            pageIndex = totalPage;
	        }

	        criteria.addOrder(org.hibernate.criterion.Order.desc("id"));
	        criteria.setFirstResult((pageIndex - 1) * pageSize);
	        criteria.setMaxResults(pageSize);

	        List<Transaction> transactions = criteria.list();

	        return new Page<Transaction>(pageIndex, totalPage, pageSize, totalSize, transactions);
		}
}