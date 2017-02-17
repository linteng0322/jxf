package com.jxf.oa.dao;

import java.util.List;

import org.hibernate.Criteria;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Memo;

public interface MemoDAO extends BaseDAO {
    
	public int findTotalSize(Criteria criteria);

	public Page<Memo> findAllMemo(Integer page, int pageSize, Integer userId);

	public List<Memo> findMemoListByExample(Memo memo, Integer userId);
    
}
