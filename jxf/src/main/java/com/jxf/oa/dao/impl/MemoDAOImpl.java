package com.jxf.oa.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Projections;
import org.springframework.stereotype.Component;

import com.jxf.oa.bean.Page;
import com.jxf.oa.dao.MemoDAO;
import com.jxf.oa.entity.Memo;

@Component
public class MemoDAOImpl extends BaseDAOImpl implements MemoDAO{

	    @Override
	    public int findTotalSize(Criteria criteria) {
	        criteria.setProjection(Projections.rowCount());
	        int totalSize =  ((Long)criteria.uniqueResult()).intValue();
	        criteria.setProjection(null);
	        return totalSize;
	    }

		@Override
		public Page<Memo> findAllMemo(Integer page, int pageSize, Integer userId) {
			Criteria criteria = session().createCriteria(Memo.class);
			int totalSize = findTotalSize(criteria);
	        int totalPage = totalSize / pageSize;
	        if(totalSize % pageSize != 0) {
	            totalPage += 1;
	        }

	        if(page > totalPage) {
	            page = totalPage;
	        }

	        criteria.addOrder(org.hibernate.criterion.Order.desc("id"));
	        criteria.setFirstResult((page - 1) * pageSize);
	        criteria.setMaxResults(pageSize);
	        
	        List<Memo> memolist = criteria.list();

	        return new Page<>(page, totalPage, pageSize, totalSize, memolist);
		}

		@Override
		public List<Memo> findMemoListByExample(Memo memo, Integer userId) {
			// TODO Auto-generated method stub
			return null;
		}

	    
}