import { shallowMount } from '@vue/test-utils'
import RoomPage from '@/views/RoomPage.vue'

describe('RoomPage.vue', () => {
  it('renders the component', () => {
    const wrapper = shallowMount(RoomPage, {
      global: {
        stubs: {
          YouTubePlayer: {
            template: '<div />',
            props: { videoId: { type: String, required: true } }
          }
        }
      },
      props: {
        videoId: 'test'
      }
    })
    expect(wrapper.exists()).toBe(true)
  })
})
