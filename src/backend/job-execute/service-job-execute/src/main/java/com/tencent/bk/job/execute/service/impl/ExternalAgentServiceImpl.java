/*
 *
 *  * Tencent is pleased to support the open source community by making BK-JOB蓝鲸智云作业平台 available.
 *  *
 *  * Copyright (C) 2021 THL A29 Limited, a Tencent company.  All rights reserved.
 *  *
 *  * BK-JOB蓝鲸智云作业平台 is licensed under the MIT License.
 *  *
 *  * License for BK-JOB蓝鲸智云作业平台:
 *  * --------------------------------------------------------------------
 *  * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 *  * documentation files (the "Software"), to deal in the Software without restriction, including without limitation
 *  * the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
 *  * to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *  *
 *  * The above copyright notice and this permission notice shall be included in all copies or substantial portions of
 *  * the Software.
 *  *
 *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
 *  * THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 *  * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 *  * IN THE SOFTWARE.
 *
 */

package com.tencent.bk.job.execute.service.impl;

import com.tencent.bk.job.common.gse.service.AgentStateClient;
import com.tencent.bk.job.common.model.dto.HostDTO;
import com.tencent.bk.job.execute.config.NFSExternalAgentHostConfig;
import com.tencent.bk.job.execute.service.ExternalAgentService;
import com.tencent.bk.job.execute.service.HostService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.atomic.AtomicLong;

import static com.tencent.bk.job.execute.config.GseConfig.EXECUTE_BEAN_AGENT_STATE_CLIENT;

@Slf4j
@Service
public class ExternalAgentServiceImpl implements ExternalAgentService {

    private static final String REDIS_CONFIG_KEY = "job:execute:external-agent";
    private static final String REDIS_EXTERNAL_HOSTS_KEY = "hosts";
    private static final String REDIS_KEY_UPDATE_TIME_KEY = "update-timestamp";
    private final RedisTemplate<String, Object> redisTemplate;
    private final HostService hostService;
    private final AgentStateClient agentStateClient;

    private static final AtomicLong roundRobinCnt = new AtomicLong(0);

    public ExternalAgentServiceImpl(@Qualifier("jsonRedisTemplate") RedisTemplate<String, Object> redisTemplate,
                                    NFSExternalAgentHostConfig externalAgentHostConfig,
                                    HostService hostService,
                                    @Qualifier(EXECUTE_BEAN_AGENT_STATE_CLIENT) AgentStateClient agentStateClient) {
        this.redisTemplate = redisTemplate;
        this.hostService = hostService;
        this.agentStateClient = agentStateClient;
        initExternalHostsPool(externalAgentHostConfig);
    }

    @Override
    public HostDTO getDistributeSourceHost() {
        return null;
    }

    private void initExternalHostsPool(NFSExternalAgentHostConfig configFromDeployment) {
        Object updateTimestamp =
            redisTemplate.opsForHash().get(REDIS_CONFIG_KEY, REDIS_EXTERNAL_HOSTS_KEY);

        if (updateTimestamp == null || (Long) updateTimestamp < configFromDeployment.getTimestamp()) {
            // 未缓存时外部的主机信息 或 部署时的外部主机配置更新，则刷新缓存
            cacheConfig(configFromDeployment);
        }
    }

    private void cacheConfig(NFSExternalAgentHostConfig externalAgentHostConfig) {
        redisTemplate.opsForHash().delete(REDIS_CONFIG_KEY);
        redisTemplate.opsForHash().put(
            REDIS_CONFIG_KEY,
            REDIS_KEY_UPDATE_TIME_KEY,
            externalAgentHostConfig.getTimestamp()
        );
        redisTemplate.opsForHash().put(
            REDIS_CONFIG_KEY,
            REDIS_EXTERNAL_HOSTS_KEY,
            externalAgentHostConfig.getHosts()
        );
    }

}
