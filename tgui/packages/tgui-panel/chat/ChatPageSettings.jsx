/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { useDispatch, useSelector } from 'tgui/backend';
import {
  Button,
  Collapsible,
  Divider,
  Input,
  Section,
  Stack,
} from 'tgui/components';

import {
  moveChatPageLeft,
  moveChatPageRight,
  removeChatPage,
  toggleAcceptedType,
  updateChatPage,
} from './actions';
import { MESSAGE_TYPES } from './constants';
import { selectCurrentChatPage } from './selectors';

export const ChatPageSettings = (props) => {
  const page = useSelector(selectCurrentChatPage);
  const dispatch = useDispatch();
  return (
    <Section>
      <Stack align="center">
        <Stack.Item grow={1}>
          <Input
            fluid
            value={page.name}
            onChange={(e, value) =>
              dispatch(
                updateChatPage({
                  pageId: page.id,
                  name: value,
                }),
              )
            }
          />
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
<<<<<<< HEAD
            /* Bastion of Endeavor Translation
            content="Mute"
            */
            content="Заглушить"
            /* End of Bastion of Endeavor Translation */
=======
>>>>>>> 089ba29c49 ([MIRROR] more ui fixes... (#8411))
            checked={page.hideUnreadCount}
            icon={page.hideUnreadCount ? 'bell-slash' : 'bell'}
            /* Bastion of Endeavor Translation
            tooltip="Disables unread counter"
            */
            tooltip="Скрыть индикатор непрочитанных сообщений"
            /* End of Bastion of Endeavor Translation */
            onClick={() =>
              dispatch(
                updateChatPage({
                  pageId: page.id,
                  hideUnreadCount: !page.hideUnreadCount,
                }),
              )
            }
          >
            Mute
          </Button.Checkbox>
        </Stack.Item>
        {!page.isMain ? (
          <Stack.Item>
            <Button
              icon="times"
              color="red"
              onClick={() =>
                dispatch(
                  removeChatPage({
                    pageId: page.id,
                  }),
                )
              }
            >
              {/* Bastion of Endeavor Translation
              Remove
              */}
              Удалить
              {/* End of Bastion of Endeavor Translation */}
            </Button>
          </Stack.Item>
        ) : (
          ''
        )}
      </Stack>
      <Divider />
      <Stack align="center">
        {!page.isMain ? (
          <Stack.Item>
            {/* Bastion of Endeavor Translation
            Reorder Chat:&emsp;
            */}
            Переместить вкладку:&emsp;
            {/* End of Bastion of Endeavor Translation */}
            <Button
              color="blue"
              onClick={() =>
                dispatch(
                  moveChatPageLeft({
                    pageId: page.id,
                  }),
                )
              }
            >
              &laquo;
            </Button>
            <Button
              color="blue"
              onClick={() =>
                dispatch(
                  moveChatPageRight({
                    pageId: page.id,
                  }),
                )
              }
            >
              &raquo;
            </Button>
          </Stack.Item>
        ) : (
          ''
        )}
      </Stack>
      <Divider />
      {/* Bastion of Endeavor Translation
      <Section title="Messages to display" level={2}>
      */}
      <Section title="Отображаемые сообщения" level={2}>
        {/* End of Bastion of Endeavor Translation */}
        {MESSAGE_TYPES.filter(
          (typeDef) => !typeDef.important && !typeDef.admin,
        ).map((typeDef) => (
          <Button.Checkbox
            key={typeDef.type}
            checked={page.acceptedTypes[typeDef.type]}
            onClick={() =>
              dispatch(
                toggleAcceptedType({
                  pageId: page.id,
                  type: typeDef.type,
                }),
              )
            }
          >
            {typeDef.name}
          </Button.Checkbox>
        ))}
        {/* Bastion of Endeavor Translation
        <Collapsible mt={1} color="transparent" title="Admin stuff">
        */}
        <Collapsible mt={1} color="transparent" title="Администрация">
          {/* End of Bastion of Endeavor Translation */}
          {MESSAGE_TYPES.filter(
            (typeDef) => !typeDef.important && typeDef.admin,
          ).map((typeDef) => (
            <Button.Checkbox
              key={typeDef.type}
              checked={page.acceptedTypes[typeDef.type]}
              onClick={() =>
                dispatch(
                  toggleAcceptedType({
                    pageId: page.id,
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
    </Section>
  );
};
