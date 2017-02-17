package com.jxf.oa.services;

import java.util.List;

import org.springframework.security.core.userdetails.UserDetailsService;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Memo;

/**
 * Description Here
 *
 * @author Michael
 */
public interface MemoService extends BaseService, UserDetailsService {

	Page<Memo> findAllMemo(Integer page, int pageSize, Integer id);

	List<Memo> findMemoListByExample(Memo memo, Integer id);

	
}
