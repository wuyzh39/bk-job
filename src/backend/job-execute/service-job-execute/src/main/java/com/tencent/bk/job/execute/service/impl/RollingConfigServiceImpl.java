/*
 * Tencent is pleased to support the open source community by making BK-JOB蓝鲸智云作业平台 available.
 *
 * Copyright (C) 2021 THL A29 Limited, a Tencent company.  All rights reserved.
 *
 * BK-JOB蓝鲸智云作业平台 is licensed under the MIT License.
 *
 * License for BK-JOB蓝鲸智云作业平台:
 * --------------------------------------------------------------------
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
 * to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of
 * the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
 * THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

package com.tencent.bk.job.execute.service.impl;

import com.tencent.bk.job.common.model.dto.IpDTO;
import com.tencent.bk.job.execute.dao.TaskInstanceRollingConfigDAO;
import com.tencent.bk.job.execute.model.FastTaskDTO;
import com.tencent.bk.job.execute.model.StepInstanceBaseDTO;
import com.tencent.bk.job.execute.model.TaskInstanceRollingConfigDTO;
import com.tencent.bk.job.execute.model.db.RollingConfigDO;
import com.tencent.bk.job.execute.service.RollingConfigService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
public class RollingConfigServiceImpl implements RollingConfigService {

    private final TaskInstanceRollingConfigDAO taskInstanceRollingConfigDAO;

    @Autowired
    public RollingConfigServiceImpl(TaskInstanceRollingConfigDAO taskInstanceRollingConfigDAO) {
        this.taskInstanceRollingConfigDAO = taskInstanceRollingConfigDAO;
    }

    @Override
    public List<IpDTO> getRollingServers(StepInstanceBaseDTO stepInstance) {
        long rollingConfigId = stepInstance.getRollingConfigId();
        long stepInstanceId = stepInstance.getId();
        int batch = stepInstance.getBatch();

        TaskInstanceRollingConfigDTO taskInstanceRollingConfig =
            taskInstanceRollingConfigDAO.queryRollingConfigById(rollingConfigId);
        RollingConfigDO rollingConfig = taskInstanceRollingConfig.getConfig();
        if (rollingConfig.isRollingStep(stepInstanceId)) {
            return rollingConfig.getServerBatchList().get(batch - 1).getServers();
        } else {
            return stepInstance.getTargetServers().getIpList();
        }
    }

    @Override
    public long saveRollingConfigForFastJob(FastTaskDTO fastTask) {
        TaskInstanceRollingConfigDTO taskInstanceRollingConfig = new TaskInstanceRollingConfigDTO();
        taskInstanceRollingConfig.setTaskInstanceId(fastTask.getTaskInstance().getId());
        taskInstanceRollingConfig.setConfigName("default");

        RollingConfigDO rollingConfig = new RollingConfigDO();
        rollingConfig.setName("default");
        rollingConfig.setMode(fastTask.getRollingMode());
        rollingConfig.setExpr(fastTask.getRollingExpr());
        taskInstanceRollingConfig.setConfig(rollingConfig);
        return taskInstanceRollingConfigDAO.saveRollingConfig(taskInstanceRollingConfig);
    }
}
