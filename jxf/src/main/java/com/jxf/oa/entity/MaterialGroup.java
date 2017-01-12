package com.jxf.oa.entity;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
@Entity
@Table(name = "MATERIALGROUP")
public class MaterialGroup extends IdEntity {
	
	
	private Integer id;
	private String pinming;
	private String materialgroupId;
	private String materialchildren;
	private ArrayList<Material> materialchildrenlist;

    public MaterialGroup() {
    }

    public MaterialGroup(Integer id) {
        this.id = id;
    }

    @Id
    @Column(name = "ID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }
    
    @Column(name = "PINMING")
	public String getPinming() {
		return pinming;
	}

	public void setPinming(String pinming) {
		this.pinming = pinming;
	}

	@Column(name = "MATERIALCHILDREN", nullable = false, length = 20)
	public String getMaterialchildren() {
		return materialchildren;
	}

	public void setMaterialchildren(String materialchildren) {
		this.materialchildren = materialchildren;
	}
	
	@Column(name = "MATERIALGROUPID", nullable = false, length = 20)
	public String getMaterialgroupId() {
		return materialgroupId;
	}

	public void setMaterialgroupId(String materialgroupId) {
		this.materialgroupId = materialgroupId;
	}

	public ArrayList<Material> getMaterialchildrenlist() {
		return materialchildrenlist;
	}

	public void setMaterialchildrenlist(ArrayList<Material> materialchildrenlist) {
		this.materialchildrenlist = materialchildrenlist;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		return result;
	}


	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		MaterialGroup other = (MaterialGroup) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}
}
