package com.jxf.oa.services;

import java.util.List;

import com.jxf.oa.entity.IdEntity;
import com.jxf.oa.entity.Option;

/**
 * Description Here
 *
 * @author Michael
 */
public interface OptionService extends BaseService {
    public List<Option> findByType(String type);
}
