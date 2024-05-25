/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { toFixed } from 'common/math';
import { useState } from 'react';
import { useDispatch, useSelector } from 'tgui/backend';
import {
  Box,
  Button,
  Collapsible,
  ColorBox,
  Divider,
  Dropdown,
  Flex,
  Input,
  LabeledList,
  NumberInput,
  Section,
  Stack,
  Tabs,
  TextArea,
} from 'tgui/components';

import { ChatPageSettings } from '../chat';
import {
  purgeChatMessageArchive,
  rebuildChat,
  saveChatToDisk,
} from '../chat/actions';
import { MESSAGE_TYPES } from '../chat/constants';
import { useGame } from '../game';
import { THEMES } from '../themes';
import {
  addHighlightSetting,
  changeSettingsTab,
  removeHighlightSetting,
  updateHighlightSetting,
  updateSettings,
  updateToggle,
} from './actions';
import { FONTS, MAX_HIGHLIGHT_SETTINGS, SETTINGS_TABS } from './constants';
import {
  selectActiveTab,
  selectHighlightSettingById,
  selectHighlightSettings,
  selectSettings,
} from './selectors';

export const SettingsPanel = (props) => {
  const activeTab = useSelector(selectActiveTab);
  const dispatch = useDispatch();
  return (
    <Stack fill>
      <Stack.Item>
        <Section fitted fill minHeight="8em">
          <Tabs vertical>
            {SETTINGS_TABS.map((tab) => (
              <Tabs.Tab
                key={tab.id}
                selected={tab.id === activeTab}
                onClick={() =>
                  dispatch(
                    changeSettingsTab({
                      tabId: tab.id,
                    }),
                  )
                }
              >
                {tab.name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item grow={1} basis={0}>
        {activeTab === 'general' && <SettingsGeneral />}
        {activeTab === 'limits' && <MessageLimits />}
        {activeTab === 'export' && <ExportTab />}
        {activeTab === 'chatPage' && <ChatPageSettings />}
        {activeTab === 'textHighlight' && <TextHighlightSettings />}
        {activeTab === 'adminSettings' && <AdminSettings />}
      </Stack.Item>
    </Stack>
  );
};

export const SettingsGeneral = (props) => {
  const {
    theme,
    fontFamily,
    fontSize,
    lineHeight,
    showReconnectWarning,
    prependTimestamps,
    interleave,
    interleaveColor,
  } = useSelector(selectSettings);
  const dispatch = useDispatch();
  const [freeFont, setFreeFont] = useState(false);
  return (
    <Section>
      <LabeledList>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Theme">
        */}
        <LabeledList.Item label="Тема">
          {/* End of Bastion of Endeavor Translation */}
          <Dropdown
            width="175px"
            selected={theme}
            options={THEMES}
            onSelected={(value) =>
              dispatch(
                updateSettings({
                  theme: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Font style">
        */}
        <LabeledList.Item label="Шрифт">
          {/* End of Bastion of Endeavor Translation */}
          <Stack inline align="baseline">
            <Stack.Item>
              {(!freeFont && (
                <Dropdown
                  width="175px"
                  selected={fontFamily}
                  options={FONTS}
                  onSelected={(value) =>
                    dispatch(
                      updateSettings({
                        fontFamily: value,
                      }),
                    )
                  }
                />
              )) || (
                <Input
                  value={fontFamily}
                  onChange={(e, value) =>
                    dispatch(
                      updateSettings({
                        fontFamily: value,
                      }),
                    )
                  }
                />
              )}
            </Stack.Item>
            <Stack.Item>
              <Button
<<<<<<< HEAD
                /* Bastion of Endeavor Translation
                content="Custom font"
                */
                content="Особый"
                /* End of Bastion of Endeavor Translation */
=======
>>>>>>> 089ba29c49 ([MIRROR] more ui fixes... (#8411))
                icon={freeFont ? 'lock-open' : 'lock'}
                color={freeFont ? 'good' : 'bad'}
                ml={1}
                onClick={() => {
                  setFreeFont(!freeFont);
                }}
              >
                Custom font
              </Button>
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Font size">
        */}
        <LabeledList.Item label="Размер шрифта">
          {/* End of Bastion of Endeavor Translation */}
          <NumberInput
            width="4em"
            step={1}
            stepPixelSize={10}
            minValue={8}
            maxValue={32}
            value={fontSize}
            /* Bastion of Endeavor Translation
            unit="px"
            */
            unit="пт"
            /* End of Bastion of Endeavor Translation */
            format={(value) => toFixed(value)}
            onChange={(e, value) =>
              dispatch(
                updateSettings({
                  fontSize: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Line height">
        */}
        <LabeledList.Item label="Высота строки">
          {/* End of Bastion of Endeavor Translation */}
          <NumberInput
            width="4em"
            step={0.01}
            stepPixelSize={2}
            minValue={0.8}
            maxValue={5}
            value={lineHeight}
            format={(value) => toFixed(value, 2)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  lineHeight: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Enable disconnection/afk warning">
        */}
        <LabeledList.Item label="Отображать уведомление о неактивности/отключении">
          {/* End of Bastion of Endeavor Translation */}
          <Button.Checkbox
            checked={showReconnectWarning}
<<<<<<< HEAD
            content=""
            /* Bastion of Endeavor Translation
=======
>>>>>>> 089ba29c49 ([MIRROR] more ui fixes... (#8411))
            tooltip="Unchecking this will disable the red afk/reconnection warning bar at the bottom of the chat."
            */
            tooltip="При снятии галочки вы больше не будете получать уведомление об отсоединении от сервера."
            /* End of Bastion of Endeavor Translation */
            mr="5px"
            onClick={() =>
              dispatch(
                updateSettings({
                  showReconnectWarning: !showReconnectWarning,
                }),
              )
            }
          />
        </LabeledList.Item>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Interleave messages">
        */}
        <LabeledList.Item label="Чередовать фон сообщений">
          {/* End of Bastion of Endeavor Translation */}
          <Button.Checkbox
            checked={interleave}
<<<<<<< HEAD
            content=""
            /* Bastion of Endeavor Translation
=======
>>>>>>> 089ba29c49 ([MIRROR] more ui fixes... (#8411))
            tooltip="Enabling this will interleave messages."
           */
            tooltip="При включенной настройке фон сообщений будет чередовать цвет."
            /* End of Bastion of Endeavor Translation */
            mr="5px"
            onClick={() =>
              dispatch(
                updateSettings({
                  interleave: !interleave,
                }),
              )
            }
          />
          <Box inline>
            <ColorBox mr={1} color={interleaveColor} />
            <Input
              width="5em"
              monospace
              placeholder="#ffffff"
              value={interleaveColor}
              onInput={(e, value) =>
                dispatch(
                  updateSettings({
                    interleaveColor: value,
                  }),
                )
              }
            />
          </Box>
        </LabeledList.Item>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Enable chat timestamps">
       */}
        <LabeledList.Item label="Отметки времени">
          {/* End of Bastion of Endeavor Translation */}
          <Button.Checkbox
            checked={prependTimestamps}
<<<<<<< HEAD
            content=""
            /* Bastion of Endeavor Translation
=======
>>>>>>> 089ba29c49 ([MIRROR] more ui fixes... (#8411))
            tooltip="Enabling this will prepend timestamps to all messages."
           */
            tooltip="При включенной настройке перед сообщениями будет отображаться отметка времени отправки."
            /* End of Bastion of Endeavor Translation */
            mr="5px"
            onClick={() =>
              dispatch(
                updateSettings({
                  prependTimestamps: !prependTimestamps,
                }),
              )
            }
          />
          <Box inline>
            <Button icon="check" onClick={() => dispatch(rebuildChat())}>
              {/* Bastion of Endeavor Translation
              Apply now
              */}
              Применить
              {/* End of Bastion of Endeavor Translation */}
            </Button>
            <Box inline fontSize="0.9em" ml={1} color="label">
              {/* Bastion of Endeavor Translation
              Can freeze the chat for a while.
              */}
              Может вызвать подвисание.
              {/* End of Bastion of Endeavor Translation */}
            </Box>
          </Box>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export const MessageLimits = (props) => {
  const dispatch = useDispatch();
  const {
    visibleMessageLimit,
    persistentMessageLimit,
    combineMessageLimit,
    combineIntervalLimit,
    saveInterval,
  } = useSelector(selectSettings);
  return (
    <Section>
      <LabeledList>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Amount of lines to display 500-10000 (Default: 2500)">
        */}
        <LabeledList.Item label="Количество отображаемых строк от 500 до 10000 (по умочлчанию: 2500)">
          {/* End of Bastion of Endeavor Translation */}
          <NumberInput
            width="5em"
            step={100}
            stepPixelSize={2}
            minValue={500}
            maxValue={10000}
            value={visibleMessageLimit}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  visibleMessageLimit: value,
                }),
              )
            }
          />
          &nbsp;
          {visibleMessageLimit >= 5000 ? (
            <Box inline fontSize="0.9em" color="red">
              {/* Bastion of Endeavor Translation
              Impacts performance!
              */}
              Влияет на производительность!
              {/* End of Bastion of Endeavor Translation */}
            </Box>
          ) : (
            ''
          )}
        </LabeledList.Item>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Amount of visually persistent lines 0-10000 (Default: 1000)">
        */}
        <LabeledList.Item label="Количество сохраняемых визуально строчек от 0 до 10000 (по умолчанию: 1000)">
          {/* End of Bastion of Endeavor Translation */}
          <NumberInput
            width="5em"
            step={100}
            stepPixelSize={2}
            minValue={0}
            maxValue={10000}
            value={persistentMessageLimit}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  persistentMessageLimit: value,
                }),
              )
            }
          />
          &nbsp;
          {persistentMessageLimit >= 2500 ? (
            <Box inline fontSize="0.9em" color="red">
              {/* Bastion of Endeavor Translation
              Delays initialization!
              */}
              Замедляет инициализацию!
              {/* End of Bastion of Endeavor Translation */}
            </Box>
          ) : (
            ''
          )}
        </LabeledList.Item>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Amount of different lines in-between to combine 0-10 (Default: 5)">
        */}
        <LabeledList.Item label="Диапазон для объединения идентичных строк от 0 до 10 (по умолчанию: 5)">
          {/* End of Bastion of Endeavor Translation */}
          <NumberInput
            width="5em"
            step={1}
            stepPixelSize={10}
            minValue={0}
            maxValue={10}
            value={combineMessageLimit}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  combineMessageLimit: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Time to combine messages 0-10 (Default: 5 Seconds)">
        */}
        <LabeledList.Item label="Интервал для объединения идентичных строк от 0 до 10 (по умолчанию: 5 секунд)">
          {/* End of Bastion of Endeavor Translation */}
          <NumberInput
            width="5em"
            step={1}
            stepPixelSize={10}
            minValue={0}
            maxValue={10}
            value={combineIntervalLimit}
            /* Bastion of Endeavor Translation
            unit="s"
            */
            unit="сек"
            /* End of Bastion of Endeavor Translation */
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  combineIntervalLimit: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Message store interval 1-10 (Default: 10 Seconds) [Requires restart]">
       */}
        <LabeledList.Item label="Интервал сохранения сообщений от 1 до 10 (по умолчанию: 10 секунд) [требует перезапуск]">
          {/* End of Bastion of Endeavor Translation */}
          <NumberInput
            width="5em"
            step={1}
            stepPixelSize={5}
            minValue={1}
            maxValue={10}
            value={saveInterval}
            /* Bastion of Endeavor Translation
            unit="s"
            */
            unit="сек"
            /* End of Bastion of Endeavor Translation */
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  saveInterval: value,
                }),
              )
            }
          />
          &nbsp;
          {saveInterval <= 3 ? (
            <Box inline fontSize="0.9em" color="red">
              {/* Bastion of Endeavor Translation
              Warning, experimental! Might crash!
              */}
              Может вызвать вылет!
              {/* End of Bastion of Endeavor Translation */}
            </Box>
          ) : (
            ''
          )}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export const ExportTab = (props) => {
  const dispatch = useDispatch();
  const game = useGame();
  const {
    storedRounds,
    exportStart,
    exportEnd,
    logRetainRounds,
    logEnable,
    logLineCount,
    logLimit,
    totalStoredMessages,
    storedTypes,
  } = useSelector(selectSettings);
  const [purgeConfirm, setPurgeConfirm] = useState(0);
  const [logConfirm, setLogConfirm] = useState(0);
  return (
    <Section>
      <Flex align="baseline">
        {logEnable ? (
          logConfirm ? (
            <Button
              icon="ban"
              color="red"
              onClick={() => {
                dispatch(
                  updateSettings({
                    logEnable: false,
                  }),
                );
                setLogConfirm(false);
              }}
            >
              {/* Bastion of Endeavor Translation
              Disable?
              */}
              Действительно отключить сохранение истории?
              {/* End of Bastion of Endeavor Translation */}
            </Button>
          ) : (
            <Button
              icon="ban"
              color="red"
              onClick={() => {
                setLogConfirm(true);
                setTimeout(() => {
                  setLogConfirm(false);
                }, 5000);
              }}
            >
              {/* Bastion of Endeavor Translation
              Disable logging
              */}
              Отключить сохранение истории
              {/* End of Bastion of Endeavor Translation */}
            </Button>
          )
        ) : (
          <Button
            icon="download"
            color="green"
            onClick={() => {
              dispatch(
                updateSettings({
                  logEnable: true,
                }),
              );
            }}
          >
            {/* Bastion of Endeavor Translation
            Enable logging
            */}
            Включить сохранение истории
            {/* End of Bastion of Endeavor Translation */}
          </Button>
        )}
        <Flex.Item grow={1} />
        {/* Bastion of Endeavor Translation
        <Flex.Item color="label">Round ID:&nbsp;</Flex.Item>
        <Flex.Item color={game.roundId ? '' : 'red'}>
          {game.roundId ? game.roundId : 'ERROR'}
        */}
        <Flex.Item color="label">ID раунда:&nbsp;</Flex.Item>
        <Flex.Item color={game.roundId ? '' : 'red'}>
          {game.roundId ? game.roundId : 'Ошибка'}
          {/* End of Bastion of Endeavor Translation */}
        </Flex.Item>
      </Flex>
      {logEnable ? (
        <>
          <LabeledList>
            {/* Bastion of Endeavor Translation
            <LabeledList.Item label="Amount of rounds to log (1 to 8)">
           */}
            <LabeledList.Item label="Количество сохраняемых раундов (от 1 до 8)">
              {/* End of Bastion of Endeavor Translation */}
              <NumberInput
                width="5em"
                step={1}
                stepPixelSize={10}
                minValue={1}
                maxValue={8}
                value={logRetainRounds}
                format={(value) => toFixed(value)}
                onDrag={(e, value) =>
                  dispatch(
                    updateSettings({
                      logRetainRounds: value,
                    }),
                  )
                }
              />
              &nbsp;
              {logRetainRounds > 3 ? (
                <Box inline fontSize="0.9em" color="red">
                  {/* Bastion of Endeavor Translation
                  Warning, might crash!
                  */}
                  Внимание, может привести к вылетам!
                  {/* End of Bastion of Endeavor Translation */}
                </Box>
              ) : (
                ''
              )}
            </LabeledList.Item>
            {/* Bastion of Endeavor Translation
            <LabeledList.Item label="Hardlimit for the log archive (0 = inf. to 50000)">
            */}
            <LabeledList.Item label="Лимит архива логирования (0 = нет лимита, до 50000)">
              {/* End of Bastion of Endeavor Translation */}
              <NumberInput
                width="5em"
                step={500}
                stepPixelSize={10}
                minValue={0}
                maxValue={50000}
                value={logLimit}
                format={(value) => toFixed(value)}
                onDrag={(e, value) =>
                  dispatch(
                    updateSettings({
                      logLimit: value,
                    }),
                  )
                }
              />
              &nbsp;
              {logLimit > 0 ? (
                <Box
                  inline
                  fontSize="0.9em"
                  color={logLimit > 10000 ? 'red' : 'label'}
                >
                  {/* Bastion of Endeavor Translation
                  {logLimit > 15000
                    ? 'Warning, might crash! Takes priority above round retention.'
                    : 'Takes priority above round retention.'}
                  */}
                  {logLimit > 15000
                    ? 'Может привести к вылетам! Приоритет над количеством раундов.'
                    : 'Приоритет над количеством раундов.'}
                  {/* End of Bastion of Endeavor Translation */}
                </Box>
              ) : (
                ''
              )}
            </LabeledList.Item>
          </LabeledList>
          <Section>
            {/* Bastion of Endeavor Translation
            <Collapsible mt={1} color="transparent" title="Messages to log">
            */}
            <Collapsible
              mt={1}
              color="transparent"
              title="Сохраняемые сообщения"
            >
              {/* End of Bastion of Endeavor Translation */}
              {MESSAGE_TYPES.map((typeDef) => (
                <Button.Checkbox
                  key={typeDef.type}
                  checked={storedTypes[typeDef.type]}
                  onClick={() =>
                    dispatch(
                      updateToggle({
                        type: typeDef.type,
                      }),
                    )
                  }
                >
                  {typeDef.name}
                </Button.Checkbox>
              ))}
            </Collapsible>
          </Section>
        </>
      ) : (
        ''
      )}
      <LabeledList>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Export round start (0 = curr.) / end (0 = dis.)">
        */}
        <LabeledList.Item label="Экспортировать раунды от (0 = текущий) / до (0 = отключить)">
          {/* End of Bastion of Endeavor Translation */}
          <NumberInput
            width="5em"
            step={1}
            stepPixelSize={10}
            minValue={0}
            maxValue={exportEnd === 0 ? 0 : exportEnd - 1}
            value={exportStart}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  exportStart: value,
                }),
              )
            }
          />
          <NumberInput
            width="5em"
            step={1}
            stepPixelSize={10}
            minValue={exportStart === 0 ? 0 : exportStart + 1}
            maxValue={storedRounds}
            value={exportEnd}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  exportEnd: value,
                }),
              )
            }
          />
          &nbsp;
          <Box inline fontSize="0.9em" color="label">
            {/* Bastion of Endeavor Translation
            Stored Rounds:&nbsp;
            */}
            Сохранено раундов:&nbsp;
            {/* End of Bastion of Endeavor Translation */}
          </Box>
          <Box inline>{storedRounds}</Box>
        </LabeledList.Item>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Amount of lines to export (0 = inf.)">
        */}
        <LabeledList.Item label="Количество экспортируемых строк (0 = бесконечно)">
          {/* End of Bastion of Endeavor Translation */}
          <NumberInput
            width="5em"
            step={100}
            stepPixelSize={10}
            minValue={0}
            maxValue={50000}
            value={logLineCount}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  logLineCount: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Totally stored messages">
        */}
        <LabeledList.Item label="Всего сохранено сообщений">
          {/* End of Bastion of Endeavor Translation */}
          <Box>{totalStoredMessages}</Box>
        </LabeledList.Item>
      </LabeledList>
      <Divider />
      <Button icon="save" onClick={() => dispatch(saveChatToDisk())}>
        {/* Bastion of Endeavor Translation
        Save chat log
        */}
        Экспортировать историю чата
        {/* End of Bastion of Endeavor Translation */}
      </Button>
      {purgeConfirm > 0 ? (
        <Button
          icon="trash"
          color="red"
          onClick={() => {
            dispatch(purgeChatMessageArchive());
            setPurgeConfirm(2);
          }}
        >
          {/* Bastion of Endeavor Translation
          {purgeConfirm > 1 ? 'Purged!' : 'Are you sure?'}
          */}
          {purgeConfirm > 1 ? 'Архив очищен!' : 'Вы уверены?'}
          {/* End of Bastion of Endeavor Translation */}
        </Button>
      ) : (
        <Button
          icon="trash"
          color="red"
          onClick={() => {
            setPurgeConfirm(1);
            setTimeout(() => {
              setPurgeConfirm(false);
            }, 5000);
          }}
        >
          {/* Bastion of Endeavor Translation
          Purge message archive
          */}
          Очистить архив сообщений
          {/* End of Bastion of Endeavor Translation */}
        </Button>
      )}
    </Section>
  );
};

const TextHighlightSettings = (props) => {
  const highlightSettings = useSelector(selectHighlightSettings);
  const dispatch = useDispatch();
  return (
    <Section fill scrollable height="235px">
      <Section p={0}>
        <Flex direction="column">
          {highlightSettings.map((id, i) => (
            <TextHighlightSetting
              key={i}
              id={id}
              mb={i + 1 === highlightSettings.length ? 0 : '10px'}
            />
          ))}
          {highlightSettings.length < MAX_HIGHLIGHT_SETTINGS && (
            <Flex.Item>
              <Button
                color="transparent"
                icon="plus"
<<<<<<< HEAD
                /* Bastion of Endeavor Translation
                content="Add Highlight Setting"
                */
                content="Добавить критерии выделения"
                /* End of Bastion of Endeavor Translation */
=======
>>>>>>> 089ba29c49 ([MIRROR] more ui fixes... (#8411))
                onClick={() => {
                  dispatch(addHighlightSetting());
                }}
              >
                Add Highlight Setting
              </Button>
            </Flex.Item>
          )}
        </Flex>
      </Section>
      <Divider />
      <Box>
        <Button icon="check" onClick={() => dispatch(rebuildChat())}>
          {/* Bastion of Endeavor Translation
          Apply now
          */}
          Применить
          {/* End of Bastion of Endeavor Translation */}
        </Button>
        <Box inline fontSize="0.9em" ml={1} color="label">
          {/* Bastion of Endeavor Translation
          Can freeze the chat for a while.
          */}
          Может вызвать подвисание.
          {/* End of Bastion of Endeavor Translation */}
        </Box>
      </Box>
    </Section>
  );
};

const TextHighlightSetting = (props) => {
  const { id, ...rest } = props;
  const highlightSettingById = useSelector(selectHighlightSettingById);
  const dispatch = useDispatch();
  const {
    highlightColor,
    highlightText,
    blacklistText,
    highlightWholeMessage,
    highlightBlacklist,
    matchWord,
    matchCase,
  } = highlightSettingById[id];
  return (
    <Flex.Item {...rest}>
      <Flex mb={1} color="label" align="baseline">
        <Flex.Item grow>
          <Button
<<<<<<< HEAD
            /* Bastion of Endeavor Translation
            content="Delete"
            */
            content="Удалить"
            /* End of Bastion of Endeavor Translation */
=======
>>>>>>> 089ba29c49 ([MIRROR] more ui fixes... (#8411))
            color="transparent"
            icon="times"
            onClick={() =>
              dispatch(
                removeHighlightSetting({
                  id: id,
                }),
              )
            }
          >
            Delete
          </Button>
        </Flex.Item>
        <Flex.Item>
          <Button.Checkbox
            checked={highlightBlacklist}
<<<<<<< HEAD
            /* Bastion of Endeavor Translation
            content="Highlight Blacklist"
=======
>>>>>>> 089ba29c49 ([MIRROR] more ui fixes... (#8411))
            tooltip="If this option is selected, you can blacklist senders not to highlight their messages."
            */
            content="Исключения"
            tooltip="Позволяет указать отправителей, сообщения которых не будут выделяться."
            /* End of Bastion of Endeavor Translation */
            mr="5px"
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  highlightBlacklist: !highlightBlacklist,
                }),
              )
            }
          >
            Highlight Blacklist
          </Button.Checkbox>
        </Flex.Item>
        <Flex.Item>
          <Button.Checkbox
            checked={highlightWholeMessage}
<<<<<<< HEAD
            /* Bastion of Endeavor Translation
            content="Whole Message"
=======
>>>>>>> 089ba29c49 ([MIRROR] more ui fixes... (#8411))
            tooltip="If this option is selected, the entire message will be highlighted in yellow."
            */
            content="Выделять целиком"
            tooltip="Позволяет выделять всё сообщение целиком."
            /* End of Bastion of Endeavor Translation */
            mr="5px"
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  highlightWholeMessage: !highlightWholeMessage,
                }),
              )
            }
          >
            Whole Message
          </Button.Checkbox>
        </Flex.Item>
        <Flex.Item>
          <Button.Checkbox
<<<<<<< HEAD
            /* Bastion of Endeavor Translation
            content="Exact"
            */
            content="Точное совпадение"
            /* End of Bastion of Endeavor Translation */
=======
>>>>>>> 089ba29c49 ([MIRROR] more ui fixes... (#8411))
            checked={matchWord}
            tooltipPosition="bottom-start"
            /* Bastion of Endeavor Translation
            tooltip="If this option is selected, only exact matches (no extra letters before or after) will trigger. Not compatible with punctuation. Overriden if regex is used."
            */
            tooltip="Позволяет выделять сообщения только при точном совпадении. Несовместимо с пунктуацией. Не обладает приоритетом над регулярными выражениями."
            /* End of Bastion of Endeavor Translation */
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  matchWord: !matchWord,
                }),
              )
            }
          >
            Exact
          </Button.Checkbox>
        </Flex.Item>
        <Flex.Item>
          <Button.Checkbox
<<<<<<< HEAD
            /* Bastion of Endeavor Translation
            content="Case"
=======
>>>>>>> 089ba29c49 ([MIRROR] more ui fixes... (#8411))
            tooltip="If this option is selected, the highlight will be case-sensitive."
            */
            content="Регистр"
            tooltip="Переключает чувствительность к регистру текста."
            /* End of Bastion of Endeavor Translation */
            checked={matchCase}
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  matchCase: !matchCase,
                }),
              )
            }
          >
            Case
          </Button.Checkbox>
        </Flex.Item>
        <Flex.Item shrink={0}>
          <ColorBox mr={1} color={highlightColor} />
          <Input
            width="5em"
            monospace
            placeholder="#ffffff"
            value={highlightColor}
            onInput={(e, value) =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  highlightColor: value,
                }),
              )
            }
          />
        </Flex.Item>
      </Flex>
      <TextArea
        height="3em"
        value={highlightText}
        /* Bastion of Endeavor Translation
        placeholder="Put words to highlight here. Separate terms with commas, i.e. (term1, term2, term3)"
        */
        placeholder="Введите слова, которые должны выделяться в чате. Разделяйте их запятыми (слово1, слово2, слово3)."
        /* End of Bastion of Endeavor Translation */
        onChange={(e, value) =>
          dispatch(
            updateHighlightSetting({
              id: id,
              highlightText: value,
            }),
          )
        }
      />
      {highlightBlacklist ? (
        <TextArea
          height="3em"
          value={blacklistText}
          /* Bastion of Endeavor Translation
          placeholder="Put names of senders you don't want highlighted here. Separate names with commas, i.e. (name1, name2, name3)"
          */
          placeholder="Введите имена отправителей, чьи сообщения не должны выделяться. Разделяйте их запятыми (слово1, слово2, слово3)."
          /* End of Bastion of Endeavor Translation */
          onChange={(e, value) =>
            dispatch(
              updateHighlightSetting({
                id: id,
                blacklistText: value,
              }),
            )
          }
        />
      ) : (
        ''
      )}
    </Flex.Item>
  );
};

export const AdminSettings = (props) => {
  const dispatch = useDispatch();
  const { hideImportantInAdminTab } = useSelector(selectSettings);
  return (
    <Section>
      <LabeledList>
        {/* Bastion of Endeavor Translation
        <LabeledList.Item label="Hide Important messages in admin only tabs">
        */}
        <LabeledList.Item label="Скрывать важные сообщения во вкладках администрации">
          {/* End of Bastion of Endeavor Translation */}
          <Button.Checkbox
            checked={hideImportantInAdminTab}
<<<<<<< HEAD
            content=""
            /* Bastion of Endeavor Translation
=======
>>>>>>> 089ba29c49 ([MIRROR] more ui fixes... (#8411))
            tooltip="Enabling this will hide all important messages in admin filter exclusive tabs."
            */
            tooltip="Позволяет скрывать все важные сообщения в вкладках только с фильтрами для администрации."
            /* End of Bastion of Endeavor Translation */
            mr="5px"
            onClick={() =>
              dispatch(
                updateSettings({
                  hideImportantInAdminTab: !hideImportantInAdminTab,
                }),
              )
            }
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
