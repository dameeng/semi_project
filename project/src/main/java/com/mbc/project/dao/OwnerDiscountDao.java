package com.mbc.project.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.mbc.project.dto.OwnerDiscountDto;

@Mapper
public interface OwnerDiscountDao {
    Integer findStoreNumByOwnerId(@Param("id") String id);

    Long findActiveRecordByCarNum(@Param("carNum") String carNum);

    int countDuplicate(@Param("recordId") Long recordId, @Param("storeNum") Integer storeNum);

    int insertDiscount(@Param("recordId") Long recordId,
                        @Param("storeNum") Integer storeNum,
                        @Param("freeMin") int freeMin,
                        @Param("id") String id);

    List<OwnerDiscountDto> selectDiscountHistory(@Param("storeNum") Integer storeNum);
}