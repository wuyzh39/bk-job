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

package com.tencent.bk.job.crontab.metrics;

import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Slf4j
@Service
public class MeasureServiceImpl {

    @Autowired
    public MeasureServiceImpl(MeterRegistry meterRegistry,
                              @Autowired(required = false) ThreadPoolTaskExecutor quartzTaskExecutor) {
        // 同步线程池监控：Agent状态
        meterRegistry.gauge(
            CronMetricsConstants.NAME_CRON_QUARTZ_TASK_EXECUTOR_POOL_SIZE,
            Collections.singletonList(Tag.of(CronMetricsConstants.TAG_KEY_MODULE,
                CronMetricsConstants.TAG_VALUE_MODULE_CRON)),
            quartzTaskExecutor,
            taskExecutor -> taskExecutor.getThreadPoolExecutor().getPoolSize()
        );
        meterRegistry.gauge(
            CronMetricsConstants.NAME_CRON_QUARTZ_TASK_EXECUTOR_QUEUE_SIZE,
            Collections.singletonList(Tag.of(CronMetricsConstants.TAG_KEY_MODULE,
                CronMetricsConstants.TAG_VALUE_MODULE_CRON)),
            quartzTaskExecutor,
            taskExecutor -> taskExecutor.getThreadPoolExecutor().getQueue().size()
        );
    }
}
