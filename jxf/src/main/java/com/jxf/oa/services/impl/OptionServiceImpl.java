package com.jxf.oa.services.impl;

import com.jxf.oa.dao.GenericDAO;
import com.jxf.oa.entity.Option;
import com.jxf.oa.services.OptionService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Description Here
 *
 * @author Michael
 */
@Service
public class OptionServiceImpl extends BaseServiceImpl implements OptionService {

    @Autowired
    GenericDAO<Option> genericDAO;

    public List<Option> findByType(String type) {
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("type", type);

        List<Option> options = genericDAO.findByHql("from Option", args);

        return options;
    }

}
